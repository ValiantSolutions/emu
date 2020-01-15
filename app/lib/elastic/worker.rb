# frozen_string_literal: true

require 'elasticsearch'

module Elastic
  class Worker
    def self.build_connection(job)

      endpoint = job.alert&.search&.elastic_endpoint
      client = Elasticsearch::Client.new url: endpoint&.build_connection_string,
                                         log: true,
                                         request_timeout: 5 * 60,
                                         transport_options: {ssl: {verify: endpoint&.verify_ssl}}
      begin
        response = client.perform_request 'GET', ''
        endpoint&.status = :connectable unless response.nil?
      rescue StandardError => e
        endpoint&.status = :unconnectable
        client = nil
        job_status(job, :failed)
        raise e
      end
      endpoint&.save!
      client
    end

    def self.fetch_qualifying_indices(connection, search)
      #search_indices = []

      return ['_all'] if search&.index_array&.empty?

      search&.index_array

      # search&.index_array&.each do |i|
      #   begin
      #     index_query = connection.cat.indices index: i, format: 'json'
      #   rescue Elasticsearch::Transport::Transport::Errors::NotFound
      #     next
      #   end
      #   index_query.map { |m| search_indices.push(m['index']) }
      # end
      #search_indices
    end

    def self.build_search_hash(job)
      
      total_search = {
        'query' => {'bool' => {'must' => [{'query_string' => {'query' => job&.alert&.search&.query}}]}}
      }

      unless job.to.nil? || job.from.nil?
        start_time = job.from.strftime('%Y-%m-%dT%H:%M:%S.%3NZ').to_s
        end_time = job.to.strftime('%Y-%m-%dT%H:%M:%S.%3NZ').to_s
        range = {'range' => {'@timestamp' => {'gte' => start_time, 'lt' => end_time}}}
        total_search['query']['bool']['must'].push(range)
      end

      job.update!(raw_query: total_search.to_json)
      
      total_search
    end

    def self.temporary_search(connection, job, indices)
      # rescue search failures for temporary/preview searches; if it fails we can just return no results
      debug_result_count = Setting.first&.debug_result_count
      debug_result_count = Rails.application.config.debug_result_count if debug_result_count.nil?
      begin
        result = connection.search index: indices.join(','),
                                   body: build_search_hash(job),
                                   size: debug_result_count
      rescue StandardError
        return []
      end
      result_to_a(result)
    end

    def self.scroll_search(connection, job, indices)
      # throw an error if it fails so that the search worker will requeue the search
      result_count = Setting.first&.scroll_size
      result_count = Rails.application.config.scroll_size if result_count.nil?
      result = connection.search index: indices.join(','),
                                 scroll: '5m',
                                 body: build_search_hash(job),
                                 size: result_count

      results = result_to_a(result)

      while !results.empty? && result = connection.scroll(body: {scroll_id: result['_scroll_id']}, scroll: '5m')
        break if empty_search_results?(result)
        results += result_to_a(result)
      end
      results
    rescue StandardError => e
      job_status(job, :failed)
      raise e
    end

    def self.refresh_indices(connection, indices)
      return if indices.empty?
      connection.indices.refresh index: indices.join(',')
    end

    def self.search(job)
      connection = build_connection(job)

      return job_status(job, :failed) if connection.nil?

      job.update!(status: :searching)

      indices = fetch_qualifying_indices(connection, job&.alert&.search)

      refresh_indices(connection, indices)

      job_status(job, :searching)

      results = job&.alert.temporary? ? temporary_search(
        connection,
        job,
        indices
      ) : scroll_search(
        connection,
        job,
        indices
      )

      enqueue_results(job, results)
    end

    def self.result_to_a(raw_result)
      return [] if empty_search_results?(raw_result)
      results = raw_result&.dig('hits', 'hits')
      results.nil? || results.empty? ? [] : results
    end

    def self.enqueue_results(job, results)
      job_status(job, :templating)
      job.update!(raw_event_count: results.size)

      batch = Sidekiq::Batch.new

      batch.jobs do
        TemplateWorker.perform_async(job&.id, results)
      end
    end

    def self.empty_search_results?(raw_result)
      hits = raw_result&.dig('hits', 'hits')
      if hits.nil? || hits.empty?
        return true
      else
        return false
      end
    end

    def self.job_status(job, status)
      job.update!(status: status)
    end
  end
end