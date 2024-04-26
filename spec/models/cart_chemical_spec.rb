require 'rails_helper'

RSpec.describe CartChemical, :type => :model do
  fixtures :chemicals,:carts
  context "Validar cart_chemical" do

    it "cart_chemical ok" do
      chemical = chemicals(:one)
      cart = carts(:one)
      cart_chemical = CartChemical.new( quantity: 10, cart_id: cart.id, chemical_id: chemical.id)
      expect(cart_chemical).to be_valid
    end
    it "erro na cart_chemical" do
      cart_chemical = CartChemical.new()
      expect(cart_chemical).to_not be_valid
    end
  end
end
