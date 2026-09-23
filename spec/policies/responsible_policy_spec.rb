require "rails_helper"

RSpec.describe ResponsiblePolicy, type: :policy do
  fixtures :users, :farms, :activities

  let(:owner) { users(:henrique) }
  let(:other_user) { users(:rogerio) }
  let(:activity) { activities(:one) }
  let(:responsible) { Responsible.create!(name: "Test Responsible", activity: activity) }

  subject(:policy) { described_class.new(user, responsible) }

  describe "new?" do
    let(:user) { other_user }

    it "allows access" do
      expect(policy.new?).to be(true)
    end
  end

  describe "create?" do
    context "when user owns the activity's farm" do
      let(:user) { owner }

      it "allows access" do
        expect(policy.create?).to be(true)
      end
    end

    context "when user does not own the activity's farm" do
      let(:user) { other_user }

      it "denies access" do
        expect(policy.create?).to be(false)
      end
    end
  end

  describe "destroy?" do
    context "when user owns the activity's farm" do
      let(:user) { owner }

      it "allows access" do
        expect(policy.destroy?).to be(true)
      end
    end

    context "when user does not own the activity's farm" do
      let(:user) { other_user }

      it "denies access" do
        expect(policy.destroy?).to be(false)
      end
    end
  end
end
