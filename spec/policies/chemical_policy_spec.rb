require "rails_helper"

RSpec.describe ChemicalPolicy, type: :policy do
  fixtures :users, :chemicals

  let(:admin) { users(:henrique) }
  let(:user) { users(:carlos) }
  let(:chemical) { chemicals(:one) }

  subject(:policy) { described_class.new(current_user, chemical) }

  describe "index?" do
    context "when user is an admin" do
      let(:current_user) { admin }

      before do
        current_user.update!(is_admin: true)
      end

      it "allows access" do
        expect(policy.index?).to be(true)
      end
    end

    context "when user is not an admin" do
      let(:current_user) { user }

      it "denies access" do
        expect(policy.index?).to be_falsey
      end
    end
  end

  describe "show?" do
    let(:current_user) { user }

    it "allows access" do
      expect(policy.show?).to be(true)
    end
  end

  describe "new?" do
    context "when user is an admin" do
      let(:current_user) { admin }

      before do
        current_user.update!(is_admin: true)
      end

      it "allows access" do
        expect(policy.new?).to be(true)
      end
    end

    context "when user is not an admin" do
      let(:current_user) { user }

      it "denies access" do
        expect(policy.new?).to be_falsey
      end
    end
  end

  describe "create?" do
    context "when user is an admin" do
      let(:current_user) { admin }

      before do
        current_user.update!(is_admin: true)
      end

      it "allows access" do
        expect(policy.create?).to be(true)
      end
    end

    context "when user is not an admin" do
      let(:current_user) { user }

      it "denies access" do
        expect(policy.create?).to be_falsey
      end
    end
  end

  describe "edit?" do
    context "when user is an admin" do
      let(:current_user) { admin }

      before do
        current_user.update!(is_admin: true)
      end

      it "allows access" do
        expect(policy.edit?).to be(true)
      end
    end

    context "when user is not an admin" do
      let(:current_user) { user }

      it "denies access" do
        expect(policy.edit?).to be_falsey
      end
    end
  end

  describe "update?" do
    context "when user is an admin" do
      let(:current_user) { admin }

      before do
        current_user.update!(is_admin: true)
      end

      it "allows access" do
        expect(policy.update?).to be(true)
      end
    end

    context "when user is not an admin" do
      let(:current_user) { user }

      it "denies access" do
        expect(policy.update?).to be_falsey
      end
    end
  end

  describe "search?" do
    let(:current_user) { user }

    it "allows access" do
      expect(policy.search?).to be(true)
    end
  end

  describe "Scope" do
    let(:current_user) { user }

    subject(:resolved_scope) do
      described_class::Scope.new(current_user, Chemical.all).resolve
    end

    it "returns all chemicals ordered by product name" do
      expect(resolved_scope).to eq(Chemical.all.order(product_name: :asc))
    end
  end
end
