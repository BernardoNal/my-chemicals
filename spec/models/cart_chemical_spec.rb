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

  context "decimal precision" do
    before do
      @cart_chemical = CartChemical.new(valid_attributes)
    end

    it "accepts decimal quantities without floating point precision errors" do
      @cart_chemical.quantity = 0.15
      @cart_chemical.entry = '1'

      expect(@cart_chemical).to be_valid
    end

    it "accepts a quantity resulting from decimal calculations" do
      @cart_chemical.quantity = 0.1 + 0.05
      @cart_chemical.entry = '1'

      expect(@cart_chemical).to be_valid
    end

    it "calculates decimal stock movements without floating point errors" do
      cart_chemical = cart_chemicals(:one)

      CartChemical.create!(
        quantity: 0.15,
        cart: carts(:one),
        chemical: chemicals(:one)
      )

      3.times do
        CartChemical.create!(
          quantity: -0.05,
          cart: carts(:one),
          chemical: chemicals(:one)
        )
      end

      expect(cart_chemical.quantity_total).to eq(10.0)
    end

    it "preserves a small but valid remaining stock" do
      cart_chemical = cart_chemicals(:one)

      CartChemical.create!(
        quantity: 0.05,
        cart: carts(:one),
        chemical: chemicals(:one)
      )

      expect(cart_chemical.quantity_total).to eq(10.05)
    end

    it "allows withdrawing the entire stock" do
      cart_chemical = cart_chemicals(:one)

      adjustment = CartChemical.new(
        quantity: -10,
        cart: carts(:one),
        chemical: chemicals(:one)
      )
      adjustment.entry = '0'

      expect(adjustment).to be_valid
    end

    it "allows withdrawing the exact current stock" do
      cart_chemical = cart_chemicals(:one)

      current_stock = cart_chemical.quantity_total

      adjustment = CartChemical.new(
        quantity: -current_stock,
        cart: carts(:one),
        chemical: chemicals(:one)
      )
      adjustment.entry = '0'

      expect(adjustment).to be_valid
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

    it "rejects withdrawing more than the current stock" do
      cart_chemical = cart_chemicals(:one)

      adjustment = CartChemical.new(
        quantity: -(cart_chemical.quantity_total + 0.01),
        cart: carts(:one),
        chemical: chemicals(:one)
      )
      adjustment.entry = '0'

      expect(adjustment).not_to be_valid
      expect(adjustment.errors.details[:quantity]).to include(
        error: :above_limit
      )
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
