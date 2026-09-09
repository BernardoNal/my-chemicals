require 'rails_helper'

RSpec.describe CartChemical, type: :model do
  # Load necessary fixtures for the tests
  fixtures :chemicals, :carts, :storages, :farms, :users, :cart_chemicals

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

  context "quantity total" do
    it "returns the total quantity for approved carts in the same storage" do
      cart_chemical = cart_chemicals(:one)

      expect(cart_chemical.quantity_total).to eq(10)
    end

    it "sums quantities from multiple approved carts in the same storage" do
      CartChemical.create!(
        quantity: 20,
        cart: carts(:one),
        chemical: chemicals(:one)
      )

      cart_chemical = cart_chemicals(:one)

      expect(cart_chemical.quantity_total).to eq(30)
    end

    it "does not include quantities from another storage" do
      CartChemical.create!(
        quantity: 20,
        cart: carts(:two),
        chemical: chemicals(:one)
      )

      cart_chemical = cart_chemicals(:one)

      expect(cart_chemical.quantity_total).to eq(10)
    end

    it "does not include quantities from unapproved carts" do
      CartChemical.create!(
        quantity: 20,
        cart: carts(:three),
        chemical: chemicals(:one)
      )

      cart_chemical = cart_chemicals(:one)

      expect(cart_chemical.quantity_total).to eq(10)
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
        expect(@cart_chemical.errors.details[attr]).to include(error: :blank)
      end
    end

    # Test if the quantity is above limit
    it "quantity above limit" do
      @cart_chemical.entry = '0'
      @cart_chemical.quantity = -11

      @cart_chemical.valid?
      expect(@cart_chemical.errors.details[:quantity]).to include(error: :above_limit)
    end

    # Test if the quantity is negative
    it "negative quantity" do
      @cart_chemical.valid?
      expect(@cart_chemical.errors.details[:quantity]).to include(error: :invalid_quantity)
    end

    # Test if the quantity is not valid for rounding
    it "invalid rounding quantity" do
      @cart_chemical.quantity = 1.33
      @cart_chemical.valid?
      expect(@cart_chemical.errors.details[:quantity]).to include(error: :invalid_round)
    end

    context "quantity sign" do
      it "accepts a positive quantity for an entry" do
        @cart_chemical.entry = '1'
        @cart_chemical.quantity = 10

        expect(@cart_chemical).to be_valid
      end

      it "rejects a negative quantity for an entry" do
        @cart_chemical.entry = '1'
        @cart_chemical.quantity = -10

        expect(@cart_chemical).not_to be_valid
        expect(@cart_chemical.errors.details[:quantity]).to include(
          error: :invalid_quantity
        )
      end

      it "accepts a negative quantity for a withdrawal" do
        @cart_chemical.entry = '0'
        @cart_chemical.quantity = -10

        expect(@cart_chemical).to be_valid
      end

      it "rejects a positive quantity for a withdrawal" do
        @cart_chemical.entry = '0'
        @cart_chemical.quantity = 10

        expect(@cart_chemical).not_to be_valid
        expect(@cart_chemical.errors.details[:quantity]).to include(
          error: :invalid_quantity
        )
      end
    end
  end
end
