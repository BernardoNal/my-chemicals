class Storage < ApplicationRecord
  belongs_to :farm
  has_many :carts, dependent: :destroy
end
