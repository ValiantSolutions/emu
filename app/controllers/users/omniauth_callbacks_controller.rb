class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :authenticate_user!, raise: false
  
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_session_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    super
  end
end