require 'rails_helper'

RSpec.describe ActivityChemical, type: :model do
  # Load necessary fixtures for the tests
  fixtures :activities, :chemicals

  let(:valid_attributes) do
    {
      activity_id: activities(:one).id,
      chemical_id: chemicals(:one).id,
      quantity: 10.0
    }
  end

  context "ActivityChemical validation" do
    it "valid activity_chemical" do
      activity_chemical = ActivityChemical.new(valid_attributes)
      expect(activity_chemical).to be_valid
    end
  end

  context "ActivityChemical errors" do
    before do
      @activity_chemical = ActivityChemical.new(valid_attributes)
    end

    %i[activity_id chemical_id].each do |attr|
      it "blank #{attr}" do
        @activity_chemical[attr] = nil
        @activity_chemical.valid?
        expect(@activity_chemical.errors[attr]).to include("can't be blank")
      end
    end

    it "quantity must be greater than 0" do
      @activity_chemical.quantity = 0
      @activity_chemical.valid?
      expect(@activity_chemical.errors[:quantity]).to include("must be greater than 0")
    end
  end
end
