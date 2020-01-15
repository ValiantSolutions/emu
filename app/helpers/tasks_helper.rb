# frozen_string_literal: true

module TasksHelper
  def task_last_execution(task)
    if task&.last_execution_time.nil?
      'Never'
    else
      task&.last_execution_time&.in_time_zone(@user_tz)&.strftime('%m/%d/%Y @ %I:%M:%S%p')
    end
  end
end
