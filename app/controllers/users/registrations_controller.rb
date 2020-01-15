# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!, only: %i[create new otp_setup]
  after_action -> { flash.discard }, if: -> { request.xhr? }, skip: [:create]
  before_action :configure_sign_up_params, only: [:create]

  layout 'devise'

  def otp_setup
    @email = Base64.decode64(params[:email])
    @otp_secret = ROTP::Base32.random_base32(24)
    respond_to do |format|
      format.js
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :otp_secret])
  end


  def after_inactive_sign_up_path_for(resource)
    url_for :new_user_session
  end
end
