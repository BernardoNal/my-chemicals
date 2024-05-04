require 'rails_helper'

RSpec.describe CartChemicalsController, type: :controller do
  fixtures :users, :carts, :storages, :cart_chemicals, :chemicals
  before { sign_in users(:henrique) }

  describe "DELETE destroy" do
    it "deletes the cart" do
      delete :destroy, params: { id: cart_chemicals(:one).id }
      expect(response).to redirect_to(cart_path(cart_chemicals(:one).cart))
    end
  end
end
