class Chemical < ApplicationRecord
  has_many :cart_chemical, dependent: :destroy
  has_many :carts, through: :cart_chemicals
end
