FactoryBot.define do
  factory :alert_temporary, class: 'Temporary' do
    user { User.first || association(:user) }
    name { 'My Temporary Alert'}
    search { Search.first || association(:search) }
    deduplication { 'deduplicate_on_event_id' }
  end

  factory :alert, class: 'Permanent' do
    user { User.first || association(:user) }
    name { 'My Permanent Alert'}
    search { Search.first || association(:search) }
    #conditional
    #payload { Payload.first || association(:payload) }
    #conditional { Conditional.first || association(:conditional) }
    deduplication { 'deduplicate_on_event_id' }
  end
end