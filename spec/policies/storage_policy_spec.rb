require "rails_helper"

RSpec.describe StoragePolicy, type: :policy do
  fixtures :users, :farms, :storages

  let(:owner) { users(:henrique) }
  let(:other_user) { users(:rogerio) }
  let(:storage) { storages(:one) }

  subject(:policy) { described_class.new(user, storage) }

  describe "create?" do
    let(:user) { owner }

    it "allows creating a storage" do
      expect(policy.create?).to be(true)
    end
  end

  context "when user owns the storage's farm" do
    let(:user) { owner }

    it "allows updating the storage" do
      expect(policy.update?).to be(true)
    end

    it "allows destroying the storage" do
      expect(policy.destroy?).to be(true)
    end
  end

  context "when user does not own the storage's farm" do
    let(:user) { other_user }

    it "does not allow updating the storage" do
      expect(policy.update?).to be(false)
    end

    it "does not allow destroying the storage" do
      expect(policy.destroy?).to be(false)
    end
  end

  describe "Scope" do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Storage.all).resolve
    end

    context "when user owns the farm" do
      let(:user) { owner }

      it "includes storages from the user's farms" do
        expect(resolved_scope).to include(storages(:one))
        expect(resolved_scope).to include(storages(:two))
      end
    end

    context "when user does not own the farm" do
      let(:user) { other_user }

      it "does not include storages from another user's farm" do
        expect(resolved_scope).to be_empty
      end
    end
  end
end
