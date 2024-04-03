class Cart < ApplicationRecord
  # Associations
  belongs_to :storage
  has_many :cart_chemicals, dependent: :destroy
  has_many :chemicals, through: :cart_chemicals
end
