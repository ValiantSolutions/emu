# frozen_string_literal: true

class NewJobWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, dead: false
  sidekiq_options backtrace: false

  def perform(id)
    job = Job.find_by_id(id)

    return nil if job.nil?

    Elastic::Worker.search(job)
  end
end