require "rails_helper"

RSpec.describe CartChemicalPolicy, type: :policy do
  let(:user) { instance_double(User) }
  let(:cart_chemical) { instance_double(CartChemical) }

  subject(:policy) { described_class.new(user, cart_chemical) }

  describe "create?" do
    it "allows access" do
      expect(policy.create?).to be(true)
    end
  end

  describe "destroy?" do
    it "allows access" do
      expect(policy.destroy?).to be(true)
    end
  end
end
