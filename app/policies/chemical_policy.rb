class ChemicalPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    true
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def search?
    true
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
        scope.all.order(product_name: :asc)
    end
  end
end
