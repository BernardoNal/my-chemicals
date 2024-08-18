class Activity < ApplicationRecord
  belongs_to :farm
  has_many :responsibles, dependent: :destroy
  has_many :activity_chemicals, dependent: :destroy
  has_many :chemicals, through: :activity_chemicals

  validates :name, :type, :area, :farm_id, presence: true
   # Validação de formato
   validates :name, format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "só permite letras e números" }

   # Validação de valores numéricos
  validates :forecast_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Validação de comprimento
  validates :description, :resources, length: { maximum: 400 }, allow_nil: true

  # Validação personalizada para garantir que date_start seja menor que date_end
  validate :start_date_before_end_date

  private

  def start_date_before_end_date
    if date_start.present? && date_end.present? && date_start > date_end
      errors.add(:date_start, "deve ser menor que a data de término")
    end
  end
end
