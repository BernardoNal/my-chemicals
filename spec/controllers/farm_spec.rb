require 'rails_helper'

RSpec.describe FarmsController, type: :controller do
  fixtures :users, :farms

  describe "GET edit" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :edit, params: { id: farms(:one).id }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET index" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET myfarms" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :myfarms
      expect(response).to have_http_status(200)
    end
  end

  describe "GET new" do
    it "returns a 200" do
      sign_in users(:henrique)
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    let(:valid_params) do
      { farm: { name: "Nova Fazenda 2", size: "100 ha", cep: "12345678" } }
    end

    let(:invalid_params) do
      { farm: { name: "", size: "", cep: "" } }
    end

    context "when user is authenticated" do
      before { sign_in users(:henrique) }

      it "creates a new farm with valid parameters" do
        expect {
          post :create, params: valid_params
        }.to change(Farm, :count).by(1)
      end

      it "redirects to myfarms_path after creating a new farm" do
        post :create, params: valid_params
        expect(response).to redirect_to(myfarms_path)
      end

      it "does not create a new farm with invalid parameters" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Farm, :count)
      end

      it "renders the new template when parameters are invalid" do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end

      it "redirects to login page if user is not authenticated" do
        sign_out :user
        post :create, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT update" do
    it "updates the farm" do
      sign_in users(:henrique)
      put :update, params: { id: farms(:one).id, farm: { name: "Updated Farm" } }
      expect(response).to redirect_to(myfarms_path)
    end
  end

  describe "DELETE destroy" do
    it "deletes the farm" do
      sign_in users(:henrique)
      delete :destroy, params: { id: farms(:one).id }
      expect(response).to redirect_to(myfarms_path)
    end
  end
end
