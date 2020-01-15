# frozen_string_literal: true

class PruneJobHistoryWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, dead: false
  sidekiq_options backtrace: false

  def perform
    history_prune_age = Setting.first&.job_history_age
    history_prune_age = Rails.application.config.job_history_age if history_prune_age.nil? || history_prune_age.zero?
    Job.where(updated_at: history_prune_age.days.ago..1.days.ago)&.each do |j|
      j.destroy!
    end
  end
end