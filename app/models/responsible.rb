class Responsible < ApplicationRecord
  belongs_to :activity
  belongs_to :employee, optional: true

  validates :activity_id, presence: true
  validates :name, presence: true, unless: -> { employee.present? }


  validate :unique_responsible_per_activity

  private

  def set_name_from_employee
    self.name = employee.user.full_name if employee&.user
  end

  before_validation :set_name_from_employee, if: -> { employee.present? && name.blank? }
  # Validação personalizada para garantir unicidade dentro de uma atividade
  def unique_responsible_per_activity
    if name.present? && activity.responsibles.where.not(id: id).exists?(name: name)
      errors.add(:name, "já existe um responsável com este nome para esta atividade")
    end

    if employee_id.present? && activity&.responsibles&.where.not(id: id).exists?(employee_id: employee_id)
      errors.add(:employee_id, "já existe um responsável com este funcionário para esta atividade")
    end
  end
end
