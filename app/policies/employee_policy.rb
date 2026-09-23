class EmployeePolicy < ApplicationPolicy
  def myjobs?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

 def update?
    record.farm.user == user
  end

  def destroy?
    record.farm.user == user
  end
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
     def resolve
      scope.where(user: user)
     end
  end
end
