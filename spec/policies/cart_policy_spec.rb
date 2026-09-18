require "rails_helper"

RSpec.describe CartPolicy, type: :policy do
  fixtures :users, :carts, :storages

  let(:user) { users(:henrique) }
  let(:cart) { carts(:one) }

  subject(:policy) { described_class.new(user, cart) }

  describe "show?" do
    context "when the cart is not approved" do
      let(:cart) { carts(:three) }

      it "allows access" do
        expect(policy.show?).to be(true)
      end
    end

    context "when the cart is approved" do
      let(:cart) { carts(:one) }

      it "denies access" do
        expect(policy.show?).to be_falsey
      end
    end
  end

  describe "create?" do
    it "allows access" do
      expect(policy.create?).to be(true)
    end
  end

  describe "update?" do
    it "allows access" do
      expect(policy.update?).to be(true)
    end
  end

  describe "pending?" do
    it "allows access" do
      expect(policy.pending?).to be(true)
    end
  end

  describe "record?" do
    it "allows access" do
      expect(policy.record?).to be(true)
    end
  end

  describe "destroy?" do
    it "allows access" do
      expect(policy.destroy?).to be(true)
    end
  end

  describe "Scope" do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Cart.all).resolve
    end

    context "when user has access to the storage" do
      it "includes carts from the user's storages" do
        expect(resolved_scope).to include(carts(:one))
        expect(resolved_scope).to include(carts(:two))
        expect(resolved_scope).to include(carts(:three))
      end
    end

  end
end
