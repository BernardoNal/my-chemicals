class Storage < ApplicationRecord
  belongs_to :farm
  has_many :carts, dependent: :destroy
  validates :farm_id, :name, :size, :capacity, presence: true
end
