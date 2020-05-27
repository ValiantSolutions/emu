# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'jbuilder', '~> 2.7'
gem 'mysql2', '>= 0.4.4'
gem 'puma', '~> 3.12'
gem 'rails', '~> 6.0.2.2'
gem 'sass-rails', '~> 5'

############################################################################
gem 'ace-rails-ap'
gem 'attr_encrypted'
gem 'bootstrap', '~> 4.3.1'
gem 'chartkick'
gem 'data-confirm-modal' # , git: 'https://github.com/cellvinchung/data-confirm-modal'
gem 'devise'
gem 'devise-two-factor', '>= 2.0.0'
gem 'dotenv-rails'
gem 'elasticsearch'
gem 'faraday'
gem 'font-awesome-sass'
gem 'fugit'
gem 'groupdate'
gem 'jquery-rails'
gem 'js-routes'
gem 'liquid'
gem 'loaf'
gem 'neatjson'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-oauth2'
gem 'pony'
gem 'popper_js'
gem 'pundit'
gem 'redis-namespace'
gem 'rotp'
gem 'rqrcode'
gem 'ruby-trello'
gem 'sassc-rails'
gem 'sidekiq'
gem 'sidekiq-batch'
gem 'sidekiq-cron'
gem 'slack-ruby-client'
gem 'slim-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
############################################################################

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'rufo'
  gem 'selenium-webdriver'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'webdrivers'
  gem 'newrelic_rpm'
  # gem 'logstasher'
end

# group :test do

#   # gem 'rspec-core', git: 'https://github.com/rspec/rspec-core'
#   # gem 'rspec-expectations', git: 'https://github.com/rspec/rspec-expectations'
#   # gem 'rspec-mocks', git: 'https://github.com/rspec/rspec-mocks'
#   # gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails', branch: '4-0-dev'
#   # gem 'rspec-support', git: 'https://github.com/rspec/rspec-support'
# end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'regressor', git: 'https://github.com/ndea/regressor.git', branch: 'master'
  #gem 'rspec-rails', '~> 4.0.0.beta3'
  
  #gem 'zapata', git: 'https://github.com/marcinruszkiewicz/zapata', branch: 'ruby-rails-update'
  %w[rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails', branch: '4-0-maintenance' # Previously '4-0-dev' branch
end

group :test do
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
  gem 'rspec-sidekiq'
end
