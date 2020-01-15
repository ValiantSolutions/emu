# frozen_string_literal: true

class ScheduleWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(id, *args)
    schedule = Schedule.find_by_id(id)

    return if schedule&.alert.nil? || !schedule.enabled?
    current_time = Time.now
    
    Job.create!(
      from: current_time - schedule.range_in_seconds,
      to: current_time,
      alert: schedule.alert,
      schedule: schedule,
      status: :pending
    )
  end
end