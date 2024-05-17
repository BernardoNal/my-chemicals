require 'rails_helper'

RSpec.describe Cart, type: :model do
  # Load necessary fixtures for the tests
  fixtures :storages, :users

  # Define valid attributes for CartChemical
  let(:valid_attributes) do
    {
      requestor_id: users(:henrique).id,
      approver_id: users(:henrique).id,
      storage_id: storages(:one).id
    }
  end
  context "Cart  validation" do
    # Test if a cart  is valid with all correct attributes
    it "valid cart " do
      cart = Cart.new(valid_attributes)
      expect(cart).to be_valid
    end
  end
  context "Cart errors" do
    before do
      @cart = Cart.new(valid_attributes)
    end

    # Test each attribute for presence validation
    %i[requestor_id approver_id storage_id].each do |attr|
      it "blank #{attr}" do
        @cart[attr] = nil
        @cart.valid?
        expect(@cart.errors[attr]).to include("can't be blank")
      end
    end
  end
end
