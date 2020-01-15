module Users::AccountsHelper
  def login_provider(user)
    if user.provider.nil?
      'Database + 2FA Token'
    elsif user.provider.eql?('google_oauth2')
      'Google SSO'
    end
  end

  def approval_class(user)
    user.approved? ? 'badge-success' : 'badge-secondary'
  end

  def approval_tooltip(user)
    user.approved? ? 'Account approved' : 'Account waiting administrator approval'
  end
  
  def approval_icon(user)
    user.approved? ? 'user-check' : 'user-x'
  end

  def locked_class(user)
    user&.locked_at.nil? ? 'badge-success' : 'badge-danger'
  end

  def locked_icon(user)
    user&.locked_at.nil? ? 'unlock' : 'lock'
  end

  def locked_tooltip(user)
    user&.locked_at.nil? ? 'Account unlocked' : 'Account locked'
  end

  def admin_class(user)
    user.admin? ? 'bg-info' : 'badge-success'
  end

  def admin_icon(user)
    user.admin? ? 'zap' : 'user'
  end

  def admin_tooltip(user)
    user.admin? ? 'Administrator role' : 'User role'
  end

  def humanized_account_role(user)
    user.admin? ? 'Administrator' : 'User'
  end
end
