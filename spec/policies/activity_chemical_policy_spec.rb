require "rails_helper"

RSpec.describe ActivityChemicalPolicy, type: :policy do
  let(:user) { instance_double(User) }
  let(:activity_chemical) { instance_double(ActivityChemical) }

  subject(:policy) { described_class.new(user, activity_chemical) }

  describe "new?" do
    it "allows access" do
      expect(policy.new?).to be(true)
    end
  end

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
