# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  coverage_dir 'public/coverage'
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'devise'
#require 'database_cleaner'
require 'shoulda/matchers'
require 'factory_bot'
require 'capybara/rspec'
#require 'sidekiq/testing'

Sidekiq.logger.level = Logger::ERROR

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  
  #config.clear_all_enqueued_jobs = true # default => true
  # Whether to use terminal colours when outputting messages
  #config.enable_terminal_colours = true # default => true
  # Warn when jobs are not enqueued to Redis but to a job array
  #config.warn_when_jobs_not_processed_by_sidekiq = true # default => true

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # config.before(:suite) do
  #   DatabaseCleaner.clean_with(:truncation)
  # end
  # config.before(:each) do
  #   DatabaseCleaner.strategy = :transaction
  # end
  # config.before(:each, js: true) do
  #   DatabaseCleaner.strategy = :truncation
  # end
  # config.before(:each) do
  #   DatabaseCleaner.start
  # end
  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end
  # config.before(:all) do
  #   DatabaseCleaner.start
  # end
  # config.after(:all) do
  #   DatabaseCleaner.clean
  # end

  config.include FactoryBot::Syntax::Methods
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include RequestSpecHelper, type: :request
  config.include ControllerMacros, type: :request
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
class ActiveModel::SecurePassword::InstanceMethodsOnActivation; end