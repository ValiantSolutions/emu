# frozen_string_literal: true

FactoryBot.define do
  factory :guard do
    conditional { Conditional.first || association(:conditional) }
    doc_hash { 'DEADBEEF' }
  end
end