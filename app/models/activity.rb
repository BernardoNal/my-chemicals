class Activity < ApplicationRecord
  belongs_to :farm
  has_many :responsibles, dependent: :destroy
  has_many :activity_chemicals, dependent: :destroy
  has_many :chemicals, through: :activity_chemicals

  validates :name, :farm_id, presence: true

   # Validação de valores numéricos
  validates :forecast_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Validação de comprimento
  validates :description, :resources, length: { maximum: 400 }, allow_nil: true

  # Validação personalizada para garantir que date_start seja menor que date_end
  validate :start_date_before_end_date

  def available_chemicals
    existing_chemical_ids = activity_chemicals.pluck(:chemical_id)
    Chemical.where.not(id: existing_chemical_ids).order(product_name: :asc)
  end

  private

  def start_date_before_end_date
    if date_start.present? && date_end.present? && date_start > date_end
      errors.add(:date_start, "deve ser menor que a data de término")
    end
  end
end
