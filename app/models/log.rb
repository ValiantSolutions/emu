class Log < ApplicationRecord

  attr_encrypted :body,
                 key: Rails.application.credentials.attr_encrypted,
                 marshal: true,
                 allow_empty_value: true,
                 encode: true,
                 encode_iv: true,
                 encode_salt: true
                 
  attr_encrypted :subject,
                 key: Rails.application.credentials.attr_encrypted,
                 marshal: true,
                 allow_empty_value: true,
                 encode: true,
                 encode_iv: true,
                 encode_salt: true

  belongs_to :loggable, polymorphic: true
  belongs_to :job
end
