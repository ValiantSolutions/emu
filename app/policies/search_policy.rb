class SearchPolicy < AllowAllPolicy
  
  class Scope < Scope
    def resolve
      scope.where(permanent: true)
    end
  end
  
end