class ResponsiblePolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    record.activity.farm.user == user
  end

  def destroy?
    record.activity.farm.user == user
  end

  class Scope < Scope
    # def resolve
    #   scope.joins(:farm).where(farm: user.farms)
    # end
  end
end
