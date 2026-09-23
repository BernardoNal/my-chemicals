require 'rails_helper'

RSpec.describe ChemicalsController, type:  :controller do
  fixtures :chemicals, :users

  describe "GET index" do
    it "allows admin users" do
      user = users(:henrique)
      user.update!(is_admin: true)

      sign_in user
      get :index

      expect(response).to have_http_status(200)
    end

    it "redirects non-admin users" do
      user = users(:henrique)
      user.update!(is_admin: false)

      sign_in user
      get :index

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET new" do
    it "allows admin users" do
      user = users(:henrique)
      user.update!(is_admin: true)

      sign_in user
      get :new

      expect(response).to have_http_status(200)
    end

    it "redirects non-admin users" do
      user = users(:henrique)
      user.update!(is_admin: false)

      sign_in user
      get :new

      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {
        product_name: "Test Chemical",
        compound_product: "Test Compound",
        type_product: "Herbicide",
        area: "Test Area",
        measurement_unit: "L",
        amount: 10
      }
    end

    it "allows admin users" do
      user = users(:henrique)
      user.update!(is_admin: true)

      sign_in user
      post :create, params: { chemical: valid_params }

      expect(response).to redirect_to(chemicals_path)
    end

    it "redirects non-admin users" do
      user = users(:henrique)
      user.update!(is_admin: false)

      sign_in user
      post :create, params: { chemical: valid_params }

      expect(response).to redirect_to(root_path)
    end
  end

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

  describe "GET edit" do
    let(:chemical) { create(:chemical) }

    it "allows admin users" do
      user = users(:henrique)
      user.update!(is_admin: true)

      sign_in user
      get :edit, params: { id: chemical.id }

      expect(response).to have_http_status(200)
    end

    it "redirects non-admin users" do
      user = users(:henrique)
      user.update!(is_admin: false)

      sign_in user
      get :edit, params: { id: chemical.id }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "PUT update" do
    let(:chemical) { create(:chemical) }

    let(:valid_params) do
      {
        product_name: "Updated Chemical"
      }
    end

    it "allows admin users" do
      user = users(:henrique)
      user.update!(is_admin: true)

      sign_in user
      put :update, params: { id: chemical.id, chemical: valid_params }

      expect(response).to redirect_to(root_path)
      expect(chemical.reload.product_name).to eq("Updated Chemical")
    end

    it "redirects non-admin users" do
      user = users(:henrique)
      user.update!(is_admin: false)

      sign_in user
      put :update, params: { id: chemical.id, chemical: valid_params }

      expect(response).to redirect_to(root_path)
      expect(chemical.reload.product_name).not_to eq("Updated Chemical")
    end
  end

  describe "GET search" do
    it "allows non-admin users" do
      user = users(:henrique)
      user.update!(is_admin: false)

      sign_in user
      get :search, params: { q: "test" }

      expect(response).to have_http_status(200)
    end

    it "allows admin users" do
      user = users(:henrique)
      user.update!(is_admin: true)

      sign_in user
      get :search, params: { q: "test" }

      expect(response).to have_http_status(200)
    end
  end
end
