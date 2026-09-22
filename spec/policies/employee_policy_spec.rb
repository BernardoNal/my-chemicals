require "rails_helper"

RSpec.describe EmployeePolicy, type: :policy do
  fixtures :users, :employees, :farms

  let(:user) { users(:carlos) }
  let(:employee) { employees(:one) }

  subject(:policy) { described_class.new(user, employee) }

  describe "myjobs?" do
    it "allows access" do
      expect(policy.myjobs?).to be(true)
    end
  end

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

  describe "#update?" do
    it "allows the farm owner" do
      owner = users(:henrique)
      employee = employees(:one)

      expect(described_class.new(owner, employee).update?).to be(true)
    end

    it "denies users from another farm" do
      other_user = users(:rogerio)
      employee = employees(:one)

      expect(described_class.new(other_user, employee).update?).to be(false)
    end
  end

  describe "#destroy?" do
    it "allows the farm owner" do
      owner = users(:henrique)
      employee = employees(:one)

      expect(described_class.new(owner, employee).destroy?).to be(true)
    end

    it "denies users from another farm" do
      other_user = users(:rogerio)
      employee = employees(:one)

      expect(described_class.new(other_user, employee).destroy?).to be(false)
    end
  end

  describe "Scope" do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Employee.all).resolve
    end

    context "when the user has employees" do
      it "includes the user's employees" do
        expect(resolved_scope).to include(employees(:one))
        expect(resolved_scope).to include(employees(:three))
      end
    end

    context "when employees belong to another user" do
      let(:user) { users(:henrique) }

      it "does not include employees belonging to another user" do
        expect(resolved_scope).not_to include(employees(:one))
        expect(resolved_scope).not_to include(employees(:three))
      end
    end
  end
end
