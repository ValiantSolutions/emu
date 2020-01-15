# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  
  config.cache_classes = false

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  # config.active_support.deprecation = :stderr
  config.log_level = :warn
  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true
  #config.omniauth.test_mode = true
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      "provider" => "google_oauth2",
      "uid" => "100000000000000000000",
      "info" => {
        "name" => "John Smith",
        "email" => "john@example.com",
        "first_name" => "John",
        "last_name" => "Smith",
        "image" => "https://lh4.googleusercontent.com/photo.jpg",
        "urls" => {
          "google" => "https://plus.google.com/+JohnSmith"
        }
      },
      "credentials" => {
        "token" => "TOKEN",
        "refresh_token" => "REFRESH_TOKEN",
        "expires_at" => 1496120719,
        "expires" => true
      },
      "extra" => {
        "id_token" => "ID_TOKEN",
        "id_info" => {
          "azp" => "APP_ID",
          "aud" => "APP_ID",
          "sub" => "100000000000000000000",
          "email" => "john@example.com",
          "email_verified" => true,
          "at_hash" => "HK6E_P6Dh8Y93mRNtsDB1Q",
          "iss" => "accounts.google.com",
          "iat" => 1496117119,
          "exp" => 1496120719
        },
        "raw_info" => {
          "sub" => "100000000000000000000",
          "name" => "John Smith",
          "given_name" => "John",
          "family_name" => "Smith",
          "profile" => "https://plus.google.com/+JohnSmith",
          "picture" => "https://lh4.googleusercontent.com/photo.jpg?sz=50",
          "email" => "john@example.com",
          "email_verified" => "true",
          "locale" => "en",
          "hd" => "company.com"
        }
      }
    })

end
