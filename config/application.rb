# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Src
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    config.generators do |g|
      g.template_engine = :slim
    end

    # EMU defaults
    config.scroll_size = 500
    config.debug_result_count = 5
    config.inactive_account_age = 30
    config.job_history_age = 90
    config.default_cron = '*/30 * * * *'

    config.generators do |g|
      g.test_framework :rspec,
      fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
    end
  end
end
