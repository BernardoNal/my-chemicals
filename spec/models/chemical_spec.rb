require 'rails_helper'

RSpec.describe Chemical, type: :model do
  let(:valid_attributes) do
    {
      product_name: "Vorax",
      compound_product: "Ácido L-Glutâmico",
      type_product: 'Bio-Fertilizante',
      area: 'Milho,Laranja,Soja',
      measurement_unit: 'LT',
      amount: 1
    }
  end

  context "Chemical validation" do
    # Test if a chemical is valid with all correct attributes
    it "valid chemical" do
      chemical = Chemical.new(valid_attributes)
      expect(chemical).to be_valid
    end
  end

  context "Chemical errors" do
    before do
      @chemical = Chemical.new(valid_attributes)
    end

    # Test each attribute for presence validation
    %i[product_name compound_product type_product area measurement_unit amount].each do |attr|
      it "blank #{attr}" do
        @chemical[attr] = nil
        @chemical.valid?
        expect(@chemical.errors[attr]).to include("can't be blank")
      end
    end
  end
end
