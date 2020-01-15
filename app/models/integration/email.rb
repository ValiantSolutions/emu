# frozen_string_literal: true

module Integration
  class Email < Integration::Base
    self.table_name = 'integration_emails'

    attr_encrypted :host,
                   key: Rails.application.credentials.attr_encrypted,
                   encode: true,
                   encode_iv: true,
                   encode_salt: true
    attr_encrypted :from,
                   key: Rails.application.credentials.attr_encrypted,
                   encode: true,
                   encode_iv: true,
                   encode_salt: true
    attr_encrypted :user,
                   key: Rails.application.credentials.attr_encrypted,
                   marshal: true,
                   allow_empty_value: true,
                   encode: true,
                   encode_iv: true,
                   encode_salt: true
    attr_encrypted :password,
                   key: Rails.application.credentials.attr_encrypted,
                   marshal: true,
                   allow_empty_value: true,
                   encode: true,
                   encode_iv: true,
                   encode_salt: true

    enum authentication: %i[plain login cram_md5 auth_disabled]

    enum body_format: %i[plaintext html]

    has_many :logs, as: :loggable

    validates :name,
              presence: {
                message: 'This field is required.'
              },
              uniqueness: {
                message: 'An e-mail integration already exists with that name. Please choose another.',
                case_sensitive: false
              },
              format: {
                with: /\A[A-Za-z0-9 ]+\z/,
                message: 'Names may only contain alphanumeric and space characters.'
              }

    validates :port,
              numericality: {
                only_integer: true,
                greater_than: 0,
                less_than_or_equal_to: 65_535,
                message: 'Specifiy a port number between 1 and 65535.'
              }

    validates :host,
              presence: {
                message: 'This field is required.'
              }

    validates :from,
              presence: {
                message: 'This field is required.'
              }

    def connection
      @connection ||= Api::Email.new(self)
    end

    def send_email(to, subject, body)
      connection.send_email(to, subject, body)
    end

    def send_test_email(to)
      connection.send_email(to, 'EMU E-mail Test', 'Hello World!')
    end
  end
end