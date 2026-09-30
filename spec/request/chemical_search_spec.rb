require "rails_helper"

RSpec.describe "Chemical search", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :chemicals

  before do
    sign_in users(:henrique)
  end

  describe "searching chemicals by product name" do
    it "returns matching chemicals with formatted names" do
      get search_chemicals_path, params: { q: "Vor" }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body).to eq(
        [
          {
            "id" => chemicals(:one).id,
            "product_name" => "Vorax (1L)"
          }
        ]
      )
    end
  end

  describe "searching with no query" do
    it "returns no chemicals" do
      get search_chemicals_path

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe "searching many chemicals" do
    it "returns at most five results" do
      6.times do |index|
        Chemical.create!(
          product_name: "Search Chemical #{index}",
          compound_product: "Compound",
          type_product: "Fungicida",
          area: "Milho",
          measurement_unit: "L",
          amount: 1
        )
      end

      get search_chemicals_path, params: { q: "Search Chemical" }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body.size).to eq(5)
    end
  end
end
