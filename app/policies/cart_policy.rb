class CartPolicy < ApplicationPolicy
  def show?
    true
  end

  def new
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def record?
    true
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end