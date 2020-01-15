class AccountPolicy < AdminPolicy
  def pending?
    user.admin?
  end
end