FactoryBot.define do
  factory :elastic_endpoint do
    name { "My Sample Elastic Endpoint" }
    protocol { 'https' }
    verify_ssl { 'true' }
    address { 'elasticsearch.endpoint.com' }
    port { '9243' }
    username { 'elastic' }
    password { 'myelasticpassword' }
    user { User.first || association(:user) }
  end

  factory :invalid_protocol_elastic_endpoint, class: ElasticEndpoint do
    name { "My Broken Protocol Elastic Endpoint" }
    protocol { 'httpsx' }
    verify_ssl { 'true' }
    address { 'my.elastic.endpoint.com' }
    port { '9243' }
    user { User.first || association(:user) }
  end

  factory :invalid_elastic_endpoint, class: ElasticEndpoint do
    name { "My Broken Elastic Endpoint" }
    protocol { 'https' }
    verify_ssl { 'hello' }
    address { 'my.elastic.endpoint.com:9123' }
    port { 'notanint' }
    user { User.first || association(:user) }
  end
end