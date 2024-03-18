class CartChemical < ApplicationRecord
  attr_accessor :entry

  belongs_to :chemical
  belongs_to :cart

  validates  :quantity, :chemical_id, presence: true
  validate :check_stock
  validate :negative

  def quantity_total
    if chemical_id
      CartChemical.joins(:chemical, :cart).where(chemical: Chemical.find(chemical.id))
                                  .where(cart: { approved: true })
                                  .where(cart: { storage_id: cart.storage_id })
                                  .sum(:quantity)
    end
  end

  def check_stock
    if quantity && chemical_id
      if quantity_total < -quantity && entry == '0'
        errors.add(:quantity, message: 'above limit')
      end
    end
  end

  def negative
    if quantity && chemical_id
      if (quantity > 0 && entry == '0') || (quantity < 0 && entry == '1')
        errors.add(:quantity, message: 'invalid')
      end
    end
  end
end
