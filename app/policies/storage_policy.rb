class StoragePolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    record.farm.user == user
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.joins(:farm).where(farm: user.farms)
    end
  end
end
