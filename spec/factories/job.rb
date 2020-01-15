# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    alert { Alert.first || association(:alert_temporary) }
    to { Time.now }
    from { Time.now - 15.seconds.ago }
    schedule { Schedule.first || association(:schedule) }
    status { :pending }
  end
end

