require "rails_helper"

RSpec.describe ActivityChemicalPolicy, type: :policy do
  fixtures :users, :farms, :activities, :chemicals

  let(:owner) { users(:henrique) }
  let(:other_user) { users(:rogerio) }
  let(:activity) { activities(:one) }
  let(:activity_chemical) do
    ActivityChemical.create!(
      activity: activity,
      chemical: chemicals(:one),
      quantity: 1
    )
  end

  describe "new?" do
    it "allows access" do
      expect(described_class.new(owner, activity_chemical).new?).to be(true)
    end
  end

  describe "create?" do
    it "allows access to the farm owner" do
      expect(described_class.new(owner, activity_chemical).create?).to be(true)
    end

    it "denies access to another user" do
      expect(described_class.new(other_user, activity_chemical).create?).to be(false)
    end
  end

  describe "destroy?" do
    it "allows access to the farm owner" do
      expect(described_class.new(owner, activity_chemical).destroy?).to be(true)
    end

    it "denies access to another user" do
      expect(described_class.new(other_user, activity_chemical).destroy?).to be(false)
    end
  end
end
