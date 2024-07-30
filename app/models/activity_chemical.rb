class ActivityChemical < ApplicationRecord
  belongs_to :activity
  belongs_to :chemical

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
