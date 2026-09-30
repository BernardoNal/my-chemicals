require 'rails_helper'

RSpec.describe Responsible, type: :model do
# Load necessary fixtures for the tests
  fixtures :employees, :activities

  let(:valid_attributes) do
    {
      name: "João Silva",
      employee_id: employees(:one).id,
      activity_id: activities(:one).id
    }
  end

  context "Responsible validation" do
    it "valid responsible" do
      responsible = Responsible.new(valid_attributes)
      expect(responsible).to be_valid
    end
  end

  context "Responsible errors" do
    before do
      @responsible = Responsible.new(valid_attributes)
    end

    it "sets name from employee when name is blank" do
      @responsible.name = nil
      @responsible.valid?

      expect(@responsible.name).to eq(employees(:one).user.full_name)
    end

    it "validates activity_id presence" do
      @responsible.activity_id = nil
      @responsible.valid?

      expect(@responsible.errors[:activity_id]).to include("não pode ficar em branco")
    end
  end
end
