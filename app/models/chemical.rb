class Chemical < ApplicationRecord
  # Validations
  has_many :cart_chemicals, dependent: :destroy
  has_many :carts, through: :cart_chemicals

  validates :product_name, :compound_product, :type_product, :area, :measurement_unit, :amount, presence: true

  # Search
  include PgSearch::Model

  pg_search_scope :search_by_name,
    against: :product_name,
    ignoring: :accents,
    using: {
      tsearch: { prefix: true }
    }
end
