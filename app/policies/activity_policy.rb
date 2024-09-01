class ActivityPolicy < ApplicationPolicy
  def show?
    record.farm.user == user
  end
  def new?
    true
  end
  def create?
    true
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
