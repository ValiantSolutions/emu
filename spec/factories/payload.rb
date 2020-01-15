# frozen_string_literal: true

FactoryBot.define do
  factory :temporary_payload do
    alert { Alert.first || association(:alert_temporary) }
    type { 'Payload' }
    body { 'Hello World!' }
    body_format { 'plaintext' }
  end

  factory :payload do
    alert { Alert.first || association(:alert) }
    type { 'Payload' }
    body { 'Hello World!' }
    body_format { 'plaintext' }
  end
end