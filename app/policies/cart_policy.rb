class CartPolicy < ApplicationPolicy
  def new
    all
  end

  def create?
    all
  end

  def update?
    all
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
