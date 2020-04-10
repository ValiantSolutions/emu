# frozen_string_literal: true

class TemplateWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(job_id, results, *args)
    job = Job.find_by_id(job_id)
    return if job&.alert.nil? || job&.alert&.payload.nil? || job&.alert&.conditional.nil?
    job.update!(status: :templating)
    job.alert.payload.apply_template(job, results) #.inspect
  end
end