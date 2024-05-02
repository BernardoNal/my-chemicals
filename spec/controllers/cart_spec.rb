require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  fixtures :users, :carts, :storages, :cart_chemicals

  describe "GET index" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET show" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :show, params: { id: carts(:one).id }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET pending" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :pending
      expect(response).to have_http_status(200)
    end
  end

  describe " Patch record" do
    it "records the cart" do
      sign_in users(:henrique)
      patch :record, params: { id: carts(:one).id }
      p carts(:one).cart_chemicals
      p storages(:one).carts
      expect(response).to redirect_to(farms_path(farm_id: carts(:one).storage.farm_id, storage_id: carts(:one).storage_id))
    end
  end


  describe "DELETE destroy" do
    it "deletes the cart" do
      sign_in users(:henrique)
      delete :destroy, params: { id: carts(:one).id }
      expect(response).to redirect_to(farms_path)
    end
  end
end
