# frozen_string_literal: true

class Task < ApplicationRecord
  validates :cron,
            presence: {
              message: 'Cron expression required.'
            }

  validate :parseable?

  after_save do |t|
    sidekiq_task = Sidekiq::Cron::Job.find(t.uid)
    if sidekiq_task.nil?
      new_task = {
        t.uid => {
          'class' => t.worker.to_s,
          'cron' => t.cron
        }
      }
      Sidekiq::Cron::Job.load_from_hash new_task
    else
      sidekiq_task.cron = t.cron unless sidekiq_task.cron.eql?(t.cron)
      enabled? ? sidekiq_task.enable! : sidekiq_task.disable!
    end
  end

  def last_execution_time
    sidekiq_task = Sidekiq::Cron::Job.find(uid)
    sidekiq_task&.last_enqueue_time
  end

  def worker
    "#{type.split('::').last.singularize}Worker".constantize
  end

  def enqueue
    sidekiq_task = Sidekiq::Cron::Job.find(uid)
    sidekiq_task&.enque!
  end

  def uid
    Digest::SHA1.hexdigest type
  end

  def parseable?
    Fugit.do_parse_cron(cron)
    true
  rescue StandardError => e
    errors.add(:cron, 'Invalid cron format.')
  end
end