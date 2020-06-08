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
    user.admin? 
  end

  def destroy?
    user.admin? 
  end

  def show?
    user.admin? 
  end

  def index?
    user.admn?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end
end