class ActivityPolicy < ApplicationPolicy

  def new?
    record.farm.user == user
  end
  def create?
    record.farm.user == user
  end

  def edit?
    record.farm.user == user
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
