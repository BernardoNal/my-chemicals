class StoragePolicy < ApplicationPolicy
  def new
    user.farmer?
  end

  def create?
    user.farmer?
  end

  def update?
    record.user == user
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      if user
        scope.joins(:farm).where(farms: { user: user })
      else
        scope.none
      end
    end
  end
end
