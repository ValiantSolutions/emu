module ControllerMacros

  def login_user
    @user = User.first || FactoryBot.create(:user)
    sign_in @user
  end

  def login_admin
    @user = User.find_by_email('admin@user.com') || FactoryBot.create(:admin_account)
    sign_in @user
  end

  def set_db_user
    @user = User.first || FactoryBot.create(:user)
  end
end