FactoryBot.define do
  factory :action do
    alert { Alert.first || association(:alert_temporary) }
    integratable { Integration::Trello.first || association(:integration_trello) }
    trait :as_email do
      integratable { Integration::Email.first || association(:integration_email) }
    end
  end
end