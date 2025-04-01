class Activity < ApplicationRecord
  belongs_to :farm
  has_many :responsibles, dependent: :destroy
  has_many :activity_chemicals, dependent: :destroy
  has_many :chemicals, through: :activity_chemicals

  validates :activity_type,:area, :farm_id, presence: true

  # Validação de valores numéricos
  validates :forecast_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Validação de comprimento
  validates :description, :resources, length: { maximum: 400 }, allow_nil: true

  # Validação personalizada para garantir que date_start seja menor que date_end
  validate :start_date_before_end_date

  before_save :update_forecast_days

  def available_chemicals
    existing_chemical_ids = activity_chemicals.pluck(:chemical_id)
    Chemical.where.not(id: existing_chemical_ids).order(product_name: :asc)
  end

  def available_responsibles
    existing_employee_ids = responsibles.pluck(:employee_id).compact
    Employee.where.not(id: existing_employee_ids)
  end

  private

  def start_date_before_end_date
    if date_start.present? && date_end.present? && date_start > date_end
      errors.add(:date_start, "deve ser menor que a data de término")
    end
  end

  def update_forecast_days
    if date_start.present? && date_end.present?
      self.forecast_days = (date_end - date_start).to_i + 1
    else
      self.forecast_days = nil
    end
  end
end
