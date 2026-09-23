require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  fixtures :users, :farms, :carts, :storages, :cart_chemicals
  before { sign_in users(:henrique) }
  describe "GET index" do
    it "returns a 200" do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "GET show" do
    it "returns a 200" do
      get :show, params: { id: carts(:one).id }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end

  describe "GET pending" do
    it "returns a 200" do
      get :pending
      expect(response).to have_http_status(200)
      expect(response).to render_template(:pending)
    end
  end

  describe " Patch record" do
    it "records the cart" do
      patch :record, params: { id: carts(:one).id }
      expect(response).to redirect_to(farms_path(farm_id: carts(:one).storage.farm_id,
                                                 storage_id: carts(:one).storage_id))
    end
  end

  describe "DELETE destroy" do
    it "deletes the cart" do
      delete :destroy, params: { id: carts(:one).id }
      expect(response).to redirect_to(farms_path)
    end

    context "when the cart belongs to another farm" do
      let!(:other_storage) do
        Storage.create!(
          name: "Other Storage",
          size: "20 m2",
          farm: farms(:two)
        )
      end

      let!(:other_cart) do
        Cart.create!(
          storage: other_storage,
          requestor: users(:rogerio),
          approver: users(:rogerio),
          approved: false
        )
      end

      it "redirects to the root path" do
        delete :destroy, params: { id: other_cart.id }

        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the cart" do
        expect {
          delete :destroy, params: { id: other_cart.id }
        }.not_to change(Cart, :count)
      end
    end
  end
end
