class Chemical < ApplicationRecord
  # Validations
  has_many :cart_chemicals, dependent: :destroy
  has_many :carts, through: :cart_chemicals

  validates :product_name, :compound_product, :type_product, :area, :measurement_unit, :amount, presence: true
  validates :product_name, uniqueness:
  TYPE_PRODUCTS = ["INSETICIDA", "Adjuvante e Redutor de Espuma", "Fungicida", "FEROMÔNIO SINTÉTICO",
                   "Adjuvante e Redutor de ph", "Fertilizante Foliar", "NEMATICIDA E INSETICIDA",
                   "Acaricida", "Herbicida", "Adubo", "NEMATICIDA", "HERBICIDA", "REGULADOR DE CRESCIMENTO",
                   "HERBICIDA E REGULADOR DE CRESCIMENTO", "FUNGICIDA", "Ferilizante Mineral Misto",
                   "INSETICIDA E ACARICIDA", "Adjuvante", "Biofertilizante"]

  AMOUNTS = [1, 5, 10, 20, 50, 100]
  # Search
  include PgSearch::Model

  pg_search_scope :search_by_name,
    against: :product_name,
    ignoring: :accents,
    using: {
      tsearch: { prefix: true }
    }
end
