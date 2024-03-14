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

  def pending?
    true
  end
  def record?
    true
  end

  def destroy?
    true
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      user_storage_ids = user.storages.pluck(:id)
      scope.where(storage_id: user_storage_ids)
    end
  end
end
