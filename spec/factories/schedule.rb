# frozen_string_literal: true

FactoryBot.define do
  factory :schedule do
    user { User.first || association(:user)}
    cron { '*/5 * * * *' }
    range { '60' }
    alert { Alert.first || association(:alert_temporary) }
  end

  factory :invalid_schedule, class: Schedule do
    user { User.first || association(:user)}
    cron { 'notacronstring' }
    range { '60' }
    alert { Alert.first || association(:alert_temporary) }
  end
end