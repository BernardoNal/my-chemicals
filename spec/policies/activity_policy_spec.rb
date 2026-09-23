require "rails_helper"

RSpec.describe ActivityPolicy, type: :policy do
  fixtures :users, :farms, :activities

  let(:owner) { users(:henrique) }
  let(:other_user) { users(:rogerio) }
  let(:activity) { activities(:one) }

  subject(:policy) { described_class.new(user, activity) }

  describe "show?" do
    context "when user owns the activity's farm" do
      let(:user) { owner }

      it "allows access" do
        expect(policy.show?).to be(true)
      end
    end

    context "when user does not own the activity's farm" do
      let(:user) { other_user }

      it "denies access" do
        expect(policy.show?).to be(false)
      end
    end
  end

  describe "new?" do
    let(:user) { other_user }

    it "allows access" do
      expect(policy.new?).to be(true)
    end
  end

  describe "create?" do
    let(:user) { other_user }

    it "allows access" do
      expect(policy.create?).to be(true)
    end
  end

  describe "edit?" do
    context "when user owns the activity's farm" do
      let(:user) { owner }

      it "allows access" do
        expect(policy.edit?).to be(true)
      end
    end

    context "when user does not own the activity's farm" do
      let(:user) { other_user }

      it "denies access" do
        expect(policy.edit?).to be(false)
      end
    end
  end

  describe "update?" do
    context "when user owns the activity's farm" do
      let(:user) { owner }

      it "allows access" do
        expect(policy.update?).to be(true)
      end
    end

    context "when user does not own the activity's farm" do
      let(:user) { other_user }

      it "denies access" do
        expect(policy.update?).to be(false)
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

  describe "Scope" do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Activity.all).resolve
    end

    context "when user owns the farm" do
      let(:user) { owner }

      it "includes activities from the user's farms" do
        expect(resolved_scope).to include(activities(:one))
        expect(resolved_scope).to include(activities(:two))
      end
    end

    context "when user does not own the farm" do
      let(:user) { other_user }

      it "does not include activities from another user's farm" do
        expect(resolved_scope).to be_empty
      end
    end
  end
end
