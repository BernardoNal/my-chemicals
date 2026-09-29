require "rails_helper"

RSpec.describe "Chemical flow", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :chemicals

  before do
    users(:henrique).update!(is_admin: true)
    sign_in users(:henrique)
  end

  describe "creating a chemical" do
    it "persists the chemical with the submitted attributes" do
      expect {
        post chemicals_path, params: {
          chemical: {
            product_name: "New Chemical",
            compound_product: "New Compound",
            type_product: "Herbicide",
            area: "Soy",
            measurement_unit: "L",
            amount: 10
          }
        }
      }.to change(Chemical, :count).by(1)

      expect(response).to redirect_to(chemicals_path)

      chemical = Chemical.last

      expect(chemical.product_name).to eq("New Chemical")
      expect(chemical.compound_product).to eq("New Compound")
      expect(chemical.type_product).to eq("Herbicide")
      expect(chemical.area).to eq("Soy")
      expect(chemical.measurement_unit).to eq("L")
      expect(chemical.amount).to eq(10)
    end
  end

  describe "creating a chemical with invalid parameters" do
    it "does not persist the chemical and renders the form again" do
      expect {
        post chemicals_path, params: {
          chemical: {
            product_name: "",
            compound_product: "",
            type_product: "",
            area: "",
            measurement_unit: "",
            amount: ""
          }
        }
      }.not_to change(Chemical, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
  end
end
