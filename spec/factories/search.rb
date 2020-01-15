# frozen_string_literal: true


FactoryBot.define do
  factory :search do
    name { 'My Test Search' }
    indices { 'kibana_*' }
    query { 'machine.os: osx' }
    elastic_endpoint { ElasticEndpoint.first || association(:elastic_endpoint) }
    user { User.first || association(:user) }
  end

  factory :invalid_search, class: Search do
    name { 'My !!! Test Search ***' }
    query { 'machine.os: osx' }
    indices { 'kibana_*' }
    elastic_endpoint { ElasticEndpoint.first || association(:elastic_endpoint) }
    user { User.first || association(:user) }
  end
end