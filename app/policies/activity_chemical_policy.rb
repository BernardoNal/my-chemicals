class ActivityChemicalPolicy < ApplicationPolicy
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
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
