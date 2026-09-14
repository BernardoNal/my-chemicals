require 'rails_helper'

RSpec.describe Chemical, type: :model do
  fixtures :chemicals, :carts, :storages, :farms, :users, :cart_chemicals,
         :activities, :activity_chemicals

  let(:valid_attributes) do
    {
      product_name: "---------",
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

  context "product name uniqueness" do
    it "accepts a unique product name" do
      chemical = Chemical.new(valid_attributes)

      expect(chemical).to be_valid
    end

    it "rejects a duplicated product name" do
      Chemical.create!(valid_attributes)

      chemical = Chemical.new(valid_attributes)
      chemical.valid?

      expect(chemical.errors.details[:product_name]).to include(
        hash_including(error: :taken)
      )
    end
  end

  context "associations" do
    let(:chemical) { chemicals(:one) }

    it "has many cart chemicals" do
      expect(chemical.cart_chemicals).to contain_exactly(
        cart_chemicals(:one)
      )
    end

    it "has many carts through cart chemicals" do
      expect(chemical.carts).to contain_exactly(
        carts(:one)
      )
    end

    it "has many activity chemicals" do
      expect(chemical.activity_chemicals).to contain_exactly(
        activity_chemicals(:plantio_milho_chemical_1),
        activity_chemicals(:colheita_soja_chemical_1)
      )
    end

    it "has many activities through activity chemicals" do
      expect(chemical.activities).to contain_exactly(
        activities(:one),
        activities(:two)
      )
    end
  end

  context "search by name" do
    before do
      Chemical.create!(valid_attributes.merge(product_name: "Fertilizante"))
      Chemical.create!(valid_attributes.merge(product_name: "Fertilizante Premium"))
      Chemical.create!(valid_attributes.merge(product_name: "Herbicida"))
    end

    it "finds chemicals by product name" do
      expect(Chemical.search_by_name("Fertilizante")).to include(
        an_object_having_attributes(product_name: "Fertilizante")
      )
    end

    it "finds chemicals by product name prefix" do
      results = Chemical.search_by_name("Fert")

      expect(results.map(&:product_name)).to contain_exactly(
        "Fertilizante",
        "Fertilizante Premium"
      )
    end

    it "ignores case when searching by product name" do
      results = Chemical.search_by_name("fertilizante")

      expect(results.map(&:product_name)).to include(
        "Fertilizante",
        "Fertilizante Premium"
      )
    end

    it "ignores accents when searching by product name" do
      Chemical.create!(
        valid_attributes.merge(product_name: "Fertilizante Agrícola")
      )

      results = Chemical.search_by_name("Agricola")

      expect(results.map(&:product_name)).to include(
        "Fertilizante Agrícola"
      )
    end

    it "does not return unrelated chemicals" do
      results = Chemical.search_by_name("Fert")

      expect(results.map(&:product_name)).not_to include("Herbicida")
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

        expect(@chemical.errors.details[attr]).to include(
          error: :blank
        )
      end
    end
  end
end
