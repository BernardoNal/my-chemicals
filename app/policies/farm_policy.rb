class FarmPolicy < ApplicationPolicy
  # def index?
  #   user.farmer? || user.manager? || user.worker?
  # end

  # def show?
  #   user.farmer? || user.manager? || user.worker?
  # end

  # def new?
  #   user.farmer?
  # end

  # def create?
  #   user.farmer?
  # end

  # def edit?
  #   user.farmer? && record.user == user
  # end

  # def update?
  #   edit?
  # end

  # def destroy?
  #   edit?
  # end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
    # def resolve
    #   scope.joins(:farms_users).where(farms_users: { user_id: user.id })
    # end
  end
end
