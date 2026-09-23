class CartChemicalPolicy < ApplicationPolicy
  def create?
    record.cart.storage.farm.user == user
  end

  def destroy?
    record.cart.storage.farm.user == user
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
