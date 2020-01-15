# frozen_string_literal: true

class InactiveAccountWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, dead: false
  sidekiq_options backtrace: false

  def perform
    inactive_age = Setting.first&.inactive_account_age
    inactive_age = Rails.application.config.inactive_account_age if inactive_age.nil? || inactive_age.zero?
    inactive_users = User.where.not(last_sign_in_at: nil).where(last_sign_in_at: inactive_age.days.ago..90.days.ago)

    inactive_users&.each do |u|
      u.approved = false
      u.lock_access!
      u.save!
    end
  end
end