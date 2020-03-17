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
    user.admin? || record == user
  end

  def destroy?
    user.admin? || record == user
  end

  def show?
    user.admin? || record == user
  end
end