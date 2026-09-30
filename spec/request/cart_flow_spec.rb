require "rails_helper"

RSpec.describe "Cart flow", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :farms, :storages, :chemicals

  before do
    sign_in users(:henrique)
  end

  describe "creating and recording a stock entry" do
    it "persists the cart, chemical movement and approval" do
      expect {
        post storage_carts_path(storages(:one)), params: {
          cart: {
            entry: "1"
          }
        }
      }.to change(Cart, :count).by(1)

      expect(response).to redirect_to(
        cart_path(Cart.last, entry: "1")
      )

      cart = Cart.last

      expect {
        post cart_cart_chemicals_path(cart), params: {
          cart_chemical: {
            chemical_id: chemicals(:one).id,
            quantity: 10,
            entry: "1"
          }
        }
      }.to change(CartChemical, :count).by(1)

      expect(response).to redirect_to(
        cart_path(cart, entry: "1")
      )

      expect {
        patch cart_record_path(cart), params: {
          cart: {
            description: "Stock entry"
          }
        }
      }.to change { cart.reload.approved }.from(nil).to(true)

      expect(response).to redirect_to(
        farms_path(
          farm_id: storages(:one).farm_id,
          storage_id: storages(:one).id
        )
      )

      cart.reload

      expect(cart.date_move).to be_present
      expect(cart.description).to eq("Stock entry")
      expect(cart.cart_chemicals.count).to eq(1)
      expect(cart.cart_chemicals.first.chemical).to eq(chemicals(:one))
      expect(cart.cart_chemicals.first.quantity).to eq(10)
      expect(
        cart.cart_chemicals.sum(:quantity)
      ).to eq(10)
    end
  end

  describe "creating and recording a stock withdrawal" do
    it "persists the withdrawal and reduces the calculated stock" do
      expect {
        post storage_carts_path(storages(:one)), params: {
          cart: {
            entry: "0"
          }
        }
      }.to change(Cart, :count).by(1)

      cart = Cart.last

      expect {
        post cart_cart_chemicals_path(cart), params: {
          cart_chemical: {
            chemical_id: chemicals(:one).id,
            quantity: 5,
            entry: "0"
          }
        }
      }.to change(CartChemical, :count).by(1)

      expect(response).to redirect_to(
        cart_path(cart, entry: "0")
      )

      cart_chemical = cart.cart_chemicals.last

      expect(cart_chemical.quantity).to eq(-5)

      patch cart_record_path(cart), params: {
        cart: {
          description: "Stock withdrawal"
        }
      }

      expect(response).to redirect_to(
        farms_path(
          farm_id: storages(:one).farm_id,
          storage_id: storages(:one).id
        )
      )

      cart.reload
      cart_chemical.reload

      expect(cart.approved).to be(true)
      expect(cart.date_move).to be_present
      expect(cart.description).to eq("Stock withdrawal")
      expect(cart_chemical.quantity).to eq(-5)
      expect(cart_chemical.quantity_total).to eq(5)
    end
  end

  describe "creating a stock withdrawal above the available stock" do
    it "does not create the cart chemical" do
      post storage_carts_path(storages(:one)), params: {
        cart: {
          entry: "0"
        }
      }

      cart = Cart.last

      expect {
        post cart_cart_chemicals_path(cart), params: {
          cart_chemical: {
            chemical_id: chemicals(:one).id,
            quantity: 10.01,
            entry: "0"
          }
        }
      }.not_to change(CartChemical, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
