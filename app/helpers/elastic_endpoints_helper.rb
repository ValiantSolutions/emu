module ElasticEndpointsHelper
  def endpoint_status_badge_color(endpoint)
    status_color = "light"
    status_color = "success" if endpoint.connectable?
    status_color = "danger" if endpoint.unconnectable?
    status_color
  end

  def endpoint_status_icon(endpoint)
    icon = "check"
    icon = "x" if endpoint.unconnectable?
    icon
  end
end
