# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :alert
  belongs_to :user

  has_many :jobs, dependent: :destroy

  enum period: %i[minutes hours days weeks months]

  after_save do |s|
    sidekiq_task = s.job
    if sidekiq_task.nil?
      create_job
    else
      sidekiq_task.cron = s.cron unless sidekiq_task.cron.eql?(s.cron)
      enabled? ? sidekiq_task.enable! : sidekiq_task.disable!
    end
  end

  after_destroy do
    destroy_job
  end

  def next
    Fugit::Cron.parse(cron).next_time
  end

  def last
    Fugit::Cron.parse(cron).previous_time
  end

  def schedule_uid
    Digest::SHA1.hexdigest alert&.name
  end

  def destroy_job
    job&.destroy
  end

  def run_job
    create_job if job.nil?
    job&.enque!
  end

  def create_job
    new_task = {
      schedule_uid => {
        'class' => 'ScheduleWorker',
        'cron' => cron,
        'args' => id
      }
    }
    Sidekiq::Cron::Job.load_from_hash new_task
  end

  def range_in_seconds
    Fugit.parse("#{range} #{period}").to_sec
  end

  def job
    Sidekiq::Cron::Job.find(schedule_uid)
  end

  validates :cron,
            presence: {
              message: 'Cron expression required.'
            }

  validate :parseable?

  validates :range,
            presence: {
              message: 'Range must be specified'
            }, numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'Range must be an integer'
            },uniqueness: {
              scope: :alert_id,
              message: 'Schedule already exists with the current cron frequency',
              case_sensitive: false
            }

  validates :period,
            inclusion: {
              in: %w[minutes hours days weeks months],
              message: 'Invalid period.'
            }
            
  def parseable?
    begin
      Fugit.do_parse_cron(cron)
      true
    rescue => e
      errors.add(:cron, 'Invalid cron format.')
    end
  end
end
