# frozen_string_literal: true

FactoryBot.define do
  factory :temporary_conditional do
    alert { Alert.first || association(:alert_temporary) }
    type { 'Conditional' }
    body { '{{ true }}' }
    body_format { 'plaintext' }
  end

  factory :conditional do
    alert { Alert.first || association(:alert) }
    type { 'Conditional' }
    body { '{{ true }}' }
    body_format { 'plaintext' }
  end
end