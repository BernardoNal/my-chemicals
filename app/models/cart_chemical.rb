class CartChemical < ApplicationRecord
  belongs_to :chemical
  belongs_to :cart
end
