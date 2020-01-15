# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  skip_before_action :authenticate_user!, only: [:create, :new]
  after_action -> { flash.discard }, if: -> { request.xhr? }
  layout 'devise'

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end
end
