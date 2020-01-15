# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models

  attribute :locked, default: false

  devise :rememberable,
         :registerable,
         :lockable,
         :recoverable,
         :trackable,
         :omniauthable,
         :authenticatable,
         :two_factor_authenticatable,
         :timeoutable,
         otp_secret_encryption_key: Rails.application.credentials.otp_key,
         omniauth_providers: [:google_oauth2]

  has_many :searches
  has_many :elastic_endpoints

  after_find do
    self.locked = !locked_at.nil?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.uid = auth.uid
      user.last_sign_in_at = Time.now
      user.provider = auth.provider
      user.avatar_url = auth.info.image
      user.username = auth.info.name
      user.oauth_token = auth.credentials.token
      user.otp_required_for_login = false
      user.save
    end
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def self.send_reset_password_instructions(attributes = {})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t('devise.failure.not_approved')
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  validates :email,
            uniqueness: {
              message: 'This e-mail is already in use.',
              case_sensitive: false
            },
            presence: {
              message: 'E-mail is required.'
            }

  validates :password,
            :password_confirmation,
            presence: {
              message: 'Password field must be present.'
            },
            length: {
              minimum: 6,
              maximum: 128,
              message: 'Password must be between 6 and 128 characters long.'
            },
            confirmation: {
              message: 'Passwords do not match.'
            },
            if: :password?

  validates_confirmation_of :password, message: 'Passwords do not match.', if: :password?

  private

  def password?
    !uid.present? && !password.nil?
  end
end
