class CartChemical < ApplicationRecord
  attr_accessor :entry

  # Associations
  belongs_to :chemical
  belongs_to :cart

  # Validations
  validates  :quantity, :chemical_id, presence: true
  validate :check_stock
  validate :negative

  # Calculates the total quantity for the chemical in the associated cart's storage
  def quantity_total
    return unless chemical_id

    CartChemical.joins(:chemical, :cart)
                .where(chemical: Chemical.find(chemical_id))
                .where(cart: { approved: true, storage_id: cart.storage_id })
                .sum(:quantity)
  end

  # Validates the quantity against stock limits
  def check_stock
    return unless quantity && chemical_id
    return unless quantity_total < -quantity && entry == '0'

    errors.add(:quantity, message: 'above limit')
  end

  # Validates the quantity to prevent negative quantities
  def negative
    return unless quantity && chemical_id
    return unless (quantity.positive? && entry == '0') || (quantity.negative? && entry == '1')

    errors.add(:quantity, message: 'invalid')
  end
end
