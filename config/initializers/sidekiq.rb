schedule_file = "config/schedule.yml"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_CONNECTION'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_CONNECTION'] }
end

if Sidekiq.server?

  Sidekiq::Cron::Job.destroy_all!
  
  if File.exist?(schedule_file)
    static_jobs = YAML.load_file(schedule_file)
    Sidekiq::Cron::Job.load_from_hash if static_jobs
  end

  schedules = Schedule.where(enabled: true)

  scheduled_searches = []
  schedules&.each do |s|
    next if s&.alert.nil?

    search = {
      'name' => s&.schedule_uid,
      'class' => 'ScheduleWorker',
      'cron' => s&.cron,
      'args' => s&.id
    }

    scheduled_searches&.push(search)
  end

  tasks = Task.where(enabled: true)
  scheduled_tasks = []

  tasks.each do |t|
    task = {
      'name' => t.uid,
      'class' => t.worker.to_s,
      'cron' => t.cron
    }

    scheduled_tasks&.push(task)
  end

  Sidekiq::Cron::Job.load_from_array scheduled_searches
  Sidekiq::Cron::Job.load_from_array scheduled_tasks
end