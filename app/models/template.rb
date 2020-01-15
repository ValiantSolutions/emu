# frozen_string_literal: true

require 'templating/slack'
require 'templating/debug'
require 'templating/trello'
require 'templating/email'

class Template < ApplicationRecord
  attr_encrypted :body, key: Rails.application.credentials.attr_encrypted, encode: true, encode_iv: true, encode_salt: true

  belongs_to :alert
  has_one :log, as: :loggable, dependent: :destroy

  delegate :search, to: :alert, prefix: true

  enum body_format: %i[plaintext html]

  validate :valid_template?

  def template_vars(results)
    global_template_vars(results)
  end

  def global_template_vars(results)
    raw_events = results
    template_hash = {
      'search_name' => alert&.search&.name,
      'search_query' => alert&.search&.query,
      'endpoint_name' => alert&.search&.elastic_endpoint&.name,
      'raw_events' => raw_events,
      'raw_event_count' => raw_events.size,
      'alert_name' => alert&.name,
      'current_timestamp' => Time.now.utc.iso8601
    }
    template_hash
  end

  def parse
    Liquid::Template.parse(body)
  rescue StandardError => e
    logger.info "template model parse #{e}"
    nil
  end

  def valid_template?
    begin
      Liquid::Template.parse(body)
    rescue StandardError => e
      errors.add(:body, e)
      return false
    end
    true
  end
end
