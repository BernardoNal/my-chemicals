class FarmPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    record.user == user
  end

  def destroy?
    update?
  end

  def myfarms?
    true
  end

  class Scope < Scope
    def resolve
     # Farms do usuário
      farms = scope.where(user: user)

      # Farms de employees convidados
      invited_farms_ids = Farm.joins(:employees)
                              .where(employees: { id: user.employee_ids, invite: true })
                              .pluck(:id)

      # Une os dois conjuntos pelo id
      scope.where(id: farms.pluck(:id) + invited_farms_ids)
    end
  end
end
