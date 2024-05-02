require 'rails_helper'

RSpec.describe CartChemical, type: :model do
  # Load necessary fixtures for the tests
  fixtures :chemicals, :carts

  # Define valid attributes for CartChemical
  let(:valid_attributes) do
    {
      quantity: 10,
      cart_id: carts(:one).id,
      chemical_id: chemicals(:one).id,
      entry: '1'
    }
  end

  context "Cart Chemical validation" do
    # Test if a cart chemical is valid with all correct attributes
    it "valid cart chemical" do
      cart_chemical = CartChemical.new(valid_attributes)
      expect(cart_chemical).to be_valid
    end
  end

  context "Cart Chemical errors" do
    before do
      @cart_chemical = CartChemical.new(valid_attributes)
      @cart_chemical.quantity = -10
    end

    # Test each attribute for presence validation
    %i[quantity cart_id chemical_id].each do |attr|
      it "blank #{attr}" do
        @cart_chemical[attr] = nil
        @cart_chemical.valid?
        expect(@cart_chemical.errors[attr]).to include("can't be blank")
      end
    end

    # Test if the quantity is above limit
    it "quantity above limit" do
      @cart_chemical.entry = '0'
      @cart_chemical.valid?
      expect(@cart_chemical.errors[:quantity]).to include("above limit")
    end

    # Test if the quantity is negative
    it "negative quantity" do
      @cart_chemical.valid?
      expect(@cart_chemical.errors[:quantity]).to include("invalid")
    end

    # Test if the quantity is not valid for rounding
    it "invalid rounding quantity" do
      @cart_chemical.quantity = 1.33
      @cart_chemical.valid?
      expect(@cart_chemical.errors[:quantity]).to include("invalid for rounding")
    end
  end
end
