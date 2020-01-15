FactoryBot.define do

  factory :integration_slack, class: Integration::Slack do
    secret { "xoxp-27327454131-27148263025-628032401494-f43eda44fc4c3ebc011017d6a45dce1b" }
    trait :with_invalid_secret do
      secret { "xoxp-27327454131-27148263025-62a032401494-f43eda44fc4c3eZc011017d6a45dce1b" }
    end
    channels { '#chatops' }
    name { 'My dev slackchat' }
    status { 'connectable' }
  end

  factory :invalid_integration_slack, class: Integration::Slack do
    secret { "xoxp-27327454131-27148263025-62a032401494-f43eda44fc4c3eZc011017d6a45dce1b" }
    channels { '#chatops' }
    name { 'My dev slackchat' }
    status { 'connectable' }
  end

end