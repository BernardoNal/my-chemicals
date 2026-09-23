require "rails_helper"

RSpec.describe FarmPolicy, type: :policy do
  fixtures :users, :farms, :employees

  let(:owner) { users(:henrique) }
  let(:other_user) { users(:rogerio) }
  let(:farm) { farms(:one) }

  subject(:policy) { described_class.new(user, farm) }

  context "when user owns the farm" do
    let(:user) { owner }

    it "allows updating the farm" do
      expect(policy.update?).to be(true)
    end

    it "allows destroying the farm" do
      expect(policy.destroy?).to be(true)
    end
  end

  context "when user does not own the farm" do
    let(:user) { other_user }

    it "does not allow updating the farm" do
      expect(policy.update?).to be(false)
    end

    it "does not allow destroying the farm" do
      expect(policy.destroy?).to be(false)
    end
  end

  describe "create?" do
    let(:user) { owner }

    it "allows creating a farm" do
      expect(policy.create?).to be(true)
    end
  end

  describe "myfarms?" do
    let(:user) { owner }

    it "allows accessing my farms" do
      expect(policy.myfarms?).to be(true)
    end
  end

  describe "Scope" do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Farm.all).resolve
    end

    context "when user owns farms" do
      let(:user) { owner }

      it "includes the user's farms" do
        expect(resolved_scope).to include(farms(:one))
      end

      it "does not include farms owned by another user" do
        expect(resolved_scope).not_to include(farms(:two))
      end
    end

    context "when user is an invited employee" do
      let(:user) { users(:carlos) }

      before do
        employee = employees(:one)
        employee.user_cpf = employee.user.cpf
        employee.invite = true
        employee.save!
      end

      it "includes the invited farm" do
        expect(resolved_scope).to include(farms(:one))
      end
    end
  end
end
