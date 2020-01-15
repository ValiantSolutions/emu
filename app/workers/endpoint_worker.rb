require 'elasticsearch'

class EndpointWorker
  include Sidekiq::Worker
  
  def perform(id, *args)
    endpoint = ElasticEndpoint.find_by_id(id)
    return if endpoint.nil?
 
    begin
      client = Elasticsearch::Client.new url: endpoint.build_connection_string, log: false, request_timeout: 5, transport_options: { ssl: { verify: endpoint.verify_ssl }}
      response = client.perform_request 'GET', '_cluster/health'
      endpoint.status = :connectable unless response.nil?
    rescue 
      endpoint.status = :unconnectable
    end

    endpoint.save!
  end
end