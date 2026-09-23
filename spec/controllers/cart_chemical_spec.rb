require 'rails_helper'

RSpec.describe CartChemicalsController, type: :controller do
  fixtures :users, :farms, :carts, :storages, :cart_chemicals, :chemicals
  before { sign_in users(:henrique) }

  describe "POST create" do
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
        post :create, params: {
          cart_id: other_cart.id,
          cart_chemical: {
            chemical_id: chemicals(:one).id,
            quantity: 10,
            entry: "1"
          }
        }

        expect(response).to redirect_to(root_path)
      end

      it "does not create the cart chemical" do
        expect {
          post :create, params: {
            cart_id: other_cart.id,
            cart_chemical: {
              chemical_id: chemicals(:one).id,
              quantity: 10,
              entry: "1"
            }
          }
        }.not_to change(CartChemical, :count)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the cart" do
      delete :destroy, params: { id: cart_chemicals(:one).id }
      expect(response).to redirect_to(cart_path(cart_chemicals(:one).cart))
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

      let!(:other_cart_chemical) do
        CartChemical.create!(
          cart: other_cart,
          chemical: chemicals(:one),
          quantity: 1
        )
      end

      it "redirects to the root path" do
        delete :destroy, params: { id: other_cart_chemical.id }

        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the cart chemical" do
        expect {
          delete :destroy, params: { id: other_cart_chemical.id }
        }.not_to change(CartChemical, :count)
      end
    end
  end
end
