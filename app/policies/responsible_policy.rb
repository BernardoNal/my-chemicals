class ResponsiblePolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    record.farm.user == user
  end

  def destroy?
    record.farm.user == user
  end

  class Scope < Scope
    # def resolve
    #   scope.joins(:farm).where(farm: user.farms)
    # end
  end
end
