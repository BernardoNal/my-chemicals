class FarmPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    user.farmer? && record.user == user
  end

  def destroy?
    update?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
    # def resolve
    #   scope.joins(:farms_users).where(farms_users: { user_id: user.id })
    # end
  end
end
