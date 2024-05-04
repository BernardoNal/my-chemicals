require 'rails_helper'

RSpec.describe ChemicalsController, type:  :controller do
  fixtures :chemicals, :users
  describe "GET show" do
    let(:chemical) { create(:chemical) }
    it "returns a 200" do
      sign_in users(:henrique)
      get :show, params: { id: chemical.id }
      expect(response).to have_http_status(200)
    end
    it "return a chemical" do
      sign_in users(:henrique)
      get :show, params: { id: chemical.id }
      expect(assigns(:chemical)).to be_a(Chemical)
      expect(assigns(:chemical)).to eq(chemical)
    end
  end
end
