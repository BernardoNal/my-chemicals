class Chemical < ApplicationRecord
  has_many :cart_chemical, dependent: :destroy
end
