require "rails_helper"

RSpec.describe "Storage flow", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :farms, :storages

  before do
    sign_in users(:henrique)
  end

  describe "creating a storage" do
    it "persists the storage associated with the selected farm" do
      expect {
        post storages_path, params: {
          storage: {
            name: "Novo Galpão",
            size: "50 m2",
            farm_id: farms(:one).id
          }
        }
      }.to change(Storage, :count).by(1)

      expect(response).to redirect_to(myfarms_path)

      storage = Storage.last

      expect(storage.name).to eq("Novo Galpão")
      expect(storage.size).to eq("50 m2")
      expect(storage.farm).to eq(farms(:one))
    end
  end

  describe "creating a storage with invalid parameters" do
    it "does not persist the storage and renders the form again" do
      expect {
        post storages_path, params: {
          storage: {
            name: "",
            size: "",
            farm_id: ""
          }
        }
      }.not_to change(Storage, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
  end
end
