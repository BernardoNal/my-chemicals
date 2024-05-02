require 'rails_helper'

RSpec.describe ChemicalsController, type:  :controller do
  fixtures :chemicals, :users
  describe "GET show" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :show, params: { id: chemicals(:one).id }
      expect(response).to have_http_status(200)
    end
  end

end
