class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end

  def update?
    user.admin? || current_user == user
  end

  def destroy?
    user.admin? || current_user == user
  end

  def show?
    user.admin? || current_user == user
  end
end