require "rails_helper"

RSpec.describe "Cart report", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :farms, :storages, :chemicals, :carts, :cart_chemicals

  before do
    sign_in users(:henrique)
  end

  describe "GET /carts.pdf" do
    it "generates the stock movement report" do
      carts(:one).update!(date_move: Date.current)

      get carts_path(
        format: :pdf,
        start_date: Date.current.beginning_of_month,
        end_date: Date.current
      )

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/pdf")
      expect(response.body).to be_present
      expect(response.body).to start_with("%PDF")
    end
  end
end
