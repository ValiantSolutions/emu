# frozen_string_literal: true

module Integration
  class Slack < Integration::Base
    self.table_name = 'integration_slacks'

    attr_encrypted :channels,
                   key: Rails.application.credentials.attr_encrypted,
                   marshal: true,
                   encode: true,
                   encode_iv: true,
                   encode_salt: true
    attr_encrypted :secret,
                   key: Rails.application.credentials.attr_encrypted,
                   marshal: true,
                   encode: true,
                   encode_iv: true,
                   encode_salt: true

    has_many :logs, as: :loggable

    validate :is_valid?

    validates :secret,
              format: {
                with: /\Axoxp-[0-9]{11}-[0-9]{11}-[0-9]{12}-[0-9A-Fa-f]{32}\z/,
                message: "Invalid format. Secret keys start with 'xoxp-'."
              },
              presence: {
                message: 'This field is required.'
              }

    validates :channels,
              presence: {
                message: 'This field is required.'
              }

    validates :name,
              format: {
                with: /\A[A-Za-z0-9 ]+\z/,
                message: 'Names may only contain alphanumeric and space characters.'
              },
              uniqueness: {
                message: 'An Slack integration already exists with that name. Please choose another.',
                case_sensitive: false
              },
              presence: {
                message: 'This field is required.'
              }

    enum status: %i[connectable unconnectable unknown]

    def is_valid?
      unless connection.is_valid?
        errors.add(:secret, 'Invalid credentials') unless Rails.env.test?
        return false
      end
      true
    end

    def send_message(msg)
      connection.send_message(msg)
    end

    def send_test_message
      connection.send_message("Hello world!\n\t~emu")
    end

    def connection
      @connection ||= Api::Slack.new(self)
    end
  end
end