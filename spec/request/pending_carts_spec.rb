require "rails_helper"

RSpec.describe "Pending carts", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :farms, :storages, :carts

  before do
    sign_in users(:henrique)
    carts(:three).update!(date_move: Date.current)
  end

  describe "GET /pending" do
    it "shows pending carts and excludes approved carts" do
      get pending_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:pending)

      expect(response.body).to include("Saída ##{carts(:three).id}")
      expect(response.body).not_to include("Saída ##{carts(:one).id}")
    end

    it "does not show pending carts from another user's storage" do
      other_storage = Storage.create!(
        name: "Other Storage",
        size: "20 m2",
        farm: farms(:two)
      )

      other_cart = Cart.create!(
        storage: other_storage,
        requestor: users(:rogerio),
        approver: users(:rogerio),
        approved: false,
        date_move: Date.current
      )

      get pending_path

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("Saída ##{other_cart.id}")
    end
  end
end
