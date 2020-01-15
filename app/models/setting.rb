# frozen_string_literal: true

class Setting < ApplicationRecord
  validate :one_setting?
  validates :scroll_size,
            :debug_result_count,
            :inactive_account_age,
            :job_history_age,
            presence: {
              message: 'Required field.'
            }

  validates :scroll_size,
            :debug_result_count,
            :inactive_account_age,
            :job_history_age,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 10_000,
              message: 'Must be an integer greater than 0, and less than 10,000.'
            }

  def one_setting?
    if Setting.all.count > 1
      errors.add(:base, 'Too many settings')
      return false
    end
    true
  end
end
