require "rails_helper"

RSpec.describe "Farm flow", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :farms

  before do
    sign_in users(:henrique)
  end

  describe "creating a farm" do
    it "persists the farm associated with the current user" do
      expect {
        post farms_path, params: {
          farm: {
            name: "Nova Fazenda",
            size: "100 ha",
            cep: "49075000"
          }
        }
      }.to change(Farm, :count).by(1)

      expect(response).to redirect_to(myfarms_path)

      farm = Farm.last

      expect(farm.name).to eq("Nova Fazenda")
      expect(farm.size).to eq("100 ha")
      expect(farm.cep).to eq("49075000")
      expect(farm.user).to eq(users(:henrique))
    end
  end

  describe "creating a farm with invalid parameters" do
    it "does not persist the farm and renders the form again" do
      expect {
        post farms_path, params: {
          farm: {
            name: "",
            size: "",
            cep: ""
          }
        }
      }.not_to change(Farm, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
  end
end
