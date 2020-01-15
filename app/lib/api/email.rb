# frozen_string_literal: true

require 'pony'
require 'socket'

module Api
  class Email
    def initialize(email)
      @email = email
    end

    def send_email(to, subject, body)
      t = Thread.new do
        Thread.current.report_on_exception = false
        Rails.application.executor.wrap do
          Thread.current[:result] = Pony.mail(build_options(to, subject, body))
        end
      end
      t.join
      t[:result]
    end

    def build_options(to, subject, body)
      pony_options = {
        to: to,
        from: @email&.from,
        subject: subject,
        via: :smtp,
        via_options: {
          address: @email&.host,
          port: @email&.port,
          domain: Socket.gethostname,
          enable_starttls_auto: @email.ssl,
        }
      }

      unless @email&.auth_disabled?
        pony_options[:via_options][:authentication] = @email&.authentication
        unless @email&.user.blank? && @email&.password.blank?
          pony_options[:via_options][:user_name] = @email&.user
          pony_options[:via_options][:password] = @email&.password
        end
      end

      @email.html? ? pony_options[:html_body] = body : pony_options[:body] = body
      pony_options
    end
  end
end