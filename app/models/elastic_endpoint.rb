# frozen_string_literal: true

class ElasticEndpoint < ApplicationRecord
  attr_encrypted :address, key: Rails.application.credentials.attr_encrypted, marshal: true, allow_empty_value: true, encode: true, encode_iv: true, encode_salt: true
  attr_encrypted :username, key: Rails.application.credentials.attr_encrypted, marshal: true, allow_empty_value: true, encode: true, encode_iv: true, encode_salt: true
  attr_encrypted :password, key: Rails.application.credentials.attr_encrypted, marshal: true, allow_empty_value: true, encode: true, encode_iv: true, encode_salt: true

  belongs_to :user
  has_many :searches, dependent: :destroy

  enum protocol: %i[https http]
  enum status: %i[connectable unconnectable unknown]

  validates :name,
            presence: {
              message: 'Specify a name for this cluster.'
            },
            format: {
              with: /\A[A-Za-z0-9 ]+\z/,
              message: 'Names may only contain alphanumeric and space characters.'
            },
            uniqueness: {
              message: 'A cluster already exists with that name. Please choose another.',
              case_sensitive: false
            }

  validates :address,
            presence: {
              message: 'Specify the fully qualified domain name or IP address for this cluster.'
            },
            format: {
              with: /\A([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*/, # |\
              message: 'Specifiy address in either FQDN format (my.domain.name.com) or a valid IP address (1.2.3.4)'
            }

  validates :port,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 65_535,
              message: 'Specifiy a port number between 1 and 65535.'
            }

  validates :protocol,
            inclusion: {
              in: %w[https http],
              message: 'Protocol may only be set to HTTPS or HTTP.'
            }

  validates :status,
            inclusion: {
              in: %w[connectable unconnectable unknown],
              message: 'Invalid cluster status.'
            }

  validates :verify_ssl,
            inclusion: {
              in: [true, false],
              message: 'May only be true or false.'
            }

  def build_connection_string
    if username.blank? || password.blank?
      "#{protocol}://#{address}:#{port}"
    else
      "#{protocol}://#{username}:#{password}@#{address}:#{port}"
    end
  end
end
