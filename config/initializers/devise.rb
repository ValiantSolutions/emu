# frozen_string_literal: true

Devise.setup do |config|
  config.warden do |manager|
    manager.default_strategies(:scope => :user).unshift :two_factor_authenticatable
  end

  config.sign_in_after_reset_password = false

  config.mailer_sender = 'emu@emu.com'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.omniauth :google_oauth2, ENV['GOOGLE_OAUTH_CLIENT'], ENV['GOOGLE_OAUTH_SECRET'], {:skip_jwt => true }
  
  config.reconfirmable = false

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  config.sign_out_via = :get

  config.lock_strategy = :failed_attempts

  config.unlock_keys = [ :email ]

  config.unlock_strategy = :none
  
  config.maximum_attempts = 3

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  config.unlock_in = 1.hour

  # Warn on the last attempt before the account is locked.
  config.last_attempt_warning = true

  config.timeout_in = 3.hours

  Rails.application.config.to_prepare do
    Devise::SessionsController.layout 'devise'
    Devise::RegistrationsController.layout proc { |_controller| user_signed_in? ? 'application' : 'devise' }
    Devise::ConfirmationsController.layout 'devise'
    Devise::UnlocksController.layout 'devise'
    Devise::PasswordsController.layout 'devise'
  end

end
