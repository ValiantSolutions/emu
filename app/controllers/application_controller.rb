class ApplicationController < ActionController::Base
  #layout :layout_by_resource

  include Pundit

  protect_from_forgery with: :exception

  after_action  :verify_authorized, :except => [:index, :new], unless: :devise_controller?
  after_action  :verify_policy_scoped, :only => :index
  
  #before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_timezone

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  
  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
  end

  def activerecord_error
  end

  def after_sign_in_path_for(resource)
    dashboard_url
  end

  # def new_session_path(scope)
  #   new_user_session_path
  # end

  private
  def permission_denied
    head 403
  end

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end

  def set_timezone
    @user_tz = request.cookies['time_zone']
  end
end