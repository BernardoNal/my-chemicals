class Storage < ApplicationRecord
  # Associations
  belongs_to :farm
  has_many :carts, dependent: :destroy

  # Validations
  validates :farm_id, :name, :size, presence: true
end
