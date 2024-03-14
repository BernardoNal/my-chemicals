class CartChemical < ApplicationRecord
  attr_accessor :entry

  belongs_to :chemical
  belongs_to :cart

  validates  :quantity, presence: true
  validate :check_stock
  validate :negative

  def quantity_total
    CartChemical.joins(:chemical, :cart).where(chemical: Chemical.find(chemical.id))
                                .where(cart: { approved: true })
                                .where(cart: { storage_id: cart.storage_id })
                                .sum(:quantity)
  end

  def check_stock
    if quantity_total < -quantity && entry == '0'
      errors.add(:quantity, message: 'above limit')
    end
  end

  def negative
    if (quantity > 0 && entry == '0') || (quantity < 0 && entry == '1')
      errors.add(:quantity, message: 'invalid')
    end
  end

end
