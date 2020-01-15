# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    scroll_size { '500' }
    debug_result_count { '5' }
    inactive_account_age { '30' }
    job_history_age { '90' }
  end

end