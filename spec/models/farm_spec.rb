require 'rails_helper'

RSpec.describe Farm, :type => :model do
  # Load necessary fixtures for the tests
  fixtures :users

  # Define valid attributes for farm
  let(:valid_attributes) do
    {
      name: 'Sol Nascente',
      size: '500 ha',
      cep: '49075220',
      user_id: users(:henrique).id
    }
  end
  context "Farm  validation" do
    # Test if a farm  is valid with all correct attributes
    it "valid farm " do
      farm = Farm.new(valid_attributes)
      expect(farm).to be_valid
    end
  end
  context "Farm errors" do
    before do
      @farm = Farm.new(valid_attributes)
    end

    # Test each attribute for presence validation
    %i[name size cep user_id].each do |attr|
      it "blank #{attr}" do
        @farm[attr] = nil
        @farm.valid?
        expect(@farm.errors[attr]).to include("can't be blank")
      end
    end
  end
end
