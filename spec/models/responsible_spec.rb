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

    %i[name activity_id].each do |attr|
      it "blank #{attr}" do
        @responsible[attr] = nil
        @responsible.valid?
        expect(@responsible.errors[attr]).to include("can't be blank")
      end
    end
  end
end
