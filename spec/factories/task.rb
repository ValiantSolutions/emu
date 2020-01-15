FactoryBot.define do

  factory :inactive_account, class: Task::InactiveAccount do
    cron { '*/5 * * * *'}
    enabled { true }
  end

  factory :failed_job, class: Task::FailedJob do
    cron { '*/5 * * * *'}
    enabled { true }
  end

  factory :prune_job_history, class: Task::PruneJobHistory do
    cron { '*/5 * * * *'}
    enabled { true }
  end

end