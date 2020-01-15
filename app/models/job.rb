# frozen_string_literal: true

class Job < ApplicationRecord

  attr_encrypted :raw_query,
                 key: Rails.application.credentials.attr_encrypted,
                 marshal: true,
                 allow_empty_value: true,
                 encode: true,
                 encode_iv: true,
                 encode_salt: true

  belongs_to :alert
  belongs_to :schedule, optional: true

  has_many :logs, dependent: :destroy

  enum status: %i[pending searching templating completed failed unprocessable]

  validates :to,
            :from,
            presence: {
              message: 'Job requires to and from timestamps'
            },
            unless: :alert_temporary?

  after_create do
    batch = Sidekiq::Batch.new
    batch.on(:success, 'Job#finished_job_run', id: id)
    batch.on(:complete, 'Job#cleanup_temporary_jobs', id: id) if alert&.temporary?

    update!(bid: batch.bid)

    batch.jobs do
      NewJobWorker.perform_async(id)
    end
  end

  def cleanup_temporary_jobs(status, options)
    job = Job.find_by_id(options['id'])
    unless job.nil? || job&.alert.nil? || job&.alert&.permanent? || job&.alert&.search&.permanent
      SearchReaperWorker.perform_in(
        10.minutes,
        job&.alert&.search&.id
      )
    end
  end

  def finished_job_run(status, options)
    job = Job.find_by_id(options['id'])
    job&.update!(status: :completed)
  end

  def alert_temporary?
    alert.temporary?
  end
end
