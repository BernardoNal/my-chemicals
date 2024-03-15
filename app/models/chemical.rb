class Chemical < ApplicationRecord
  has_many :cart_chemical, dependent: :destroy
  has_many :carts, through: :cart_chemicals
  include PgSearch::Model

  pg_search_scope :search_by_name,
    against: :product_name,
    ignoring: :accents,
    using: {
      tsearch: { prefix: true }
    }
end
