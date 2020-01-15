json.extract! elastic_endpoint, :id
json.url elastic_endpoint_url(elastic_endpoint, format: :json)
json.status(elastic_endpoint.status.titleize)
json.color endpoint_status_badge_color(elastic_endpoint)