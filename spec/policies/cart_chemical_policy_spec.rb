require "rails_helper"

RSpec.describe CartChemicalPolicy, type: :policy do
  fixtures :users, :farms, :storages, :carts, :chemicals

  let(:owner) { users(:henrique) }
  let(:other_user) { users(:rogerio) }

  let(:cart_chemical) do
    CartChemical.create!(
      cart: carts(:three),
      chemical: chemicals(:one),
      quantity: 1
    )
  end

  describe "create?" do
    it "allows access to the farm owner" do
      expect(described_class.new(owner, cart_chemical).create?).to be(true)
    end

    it "denies access to another user" do
      expect(described_class.new(other_user, cart_chemical).create?).to be(false)
    end
  end

  describe "destroy?" do
    it "allows access to the farm owner" do
      expect(described_class.new(owner, cart_chemical).destroy?).to be(true)
    end

    it "denies access to another user" do
      expect(described_class.new(other_user, cart_chemical).destroy?).to be(false)
    end
  end
end
