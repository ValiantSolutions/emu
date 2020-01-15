class HomeController < ActionController::Base
  layout 'home'

  def index
    if user_signed_in?
      redirect_to :controller => 'dashboard', :action => 'index'
    else
      redirect_to new_user_session_path
    end
  end
end