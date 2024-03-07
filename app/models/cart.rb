class Cart < ApplicationRecord
  belongs_to :storage
  has_many :cart_chemical, dependent: :destroy
end
