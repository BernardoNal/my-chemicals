class Activity < ApplicationRecord
  belongs_to :farm
  has_many :responsibles
  has_many :activity_chemicals
  has_many :chemicals, through: :activity_chemicals

  validates :name, :date_start, :date_end, :type, :area, :farm_id, presence: true
end
