class Storage < ApplicationRecord
  # Associations
  belongs_to :farm
  has_many :carts, dependent: :destroy
  has_many :cart_chemicals, through: :carts
  has_many :chemicals, through: :cart_chemicals

  # Validations
  validates :farm_id, :name, :size, presence: true
end
