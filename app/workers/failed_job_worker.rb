# frozen_string_literal: true

class FailedJobWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false
  sidekiq_options backtrace: false

  def perform
    failed_jobs = Job.where(status: :failed)

    return nil if failed_jobs.empty?

    failed_jobs.each do |job|
      # validate the job has all the parts we need

      if job.schedule.nil? || job.alert.nil? || job&.alert&.search.nil?
        job.update!(status: unprocessable)
        next
      end

      next unless job.schedule.enabled || job.alert.permanent?
      Elastic::Worker.search(job)
    end
  end
end