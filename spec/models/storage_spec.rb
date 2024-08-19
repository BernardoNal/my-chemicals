require 'rails_helper'

RSpec.describe Storage, :type => :model do
  # Load necessary fixtures for the tests
  fixtures :farms
  # Define valid attributes for farm
  let(:valid_attributes) do
    {
      name: "Galpão principal",
      size: '20 m2',
      farm_id: farms(:one).id
    }
  end
  context "Storage  validation" do
    # Test if a storage  is valid with all correct attributes
    it "valid storage " do
      storage = Storage.new(valid_attributes)
      expect(storage).to be_valid
    end
  end
  context "Storage errors" do
    before do
      @storage = Storage.new(valid_attributes)
    end

    # Test each attribute for presence validation
    %i[name size  farm_id].each do |attr|
      it "blank #{attr}" do
        @storage[attr] = nil
        @storage.valid?
        expect(@storage.errors[attr]).to include("can't be blank")
      end
    end
  end
end
