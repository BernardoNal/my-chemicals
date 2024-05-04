require 'rails_helper'

RSpec.describe StoragesController, type: :controller do
  fixtures :users, :storages, :farms
  before { sign_in users(:henrique) }
  describe "GET edit" do
    it "returns a 200" do
      get :edit, params: { id: storages(:one).id }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end
  end

  describe "GET index" do
    it "returns a 200" do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    it "returns a 200" do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:valid_params) do
      { storage: {  name: "Galpão principal 2",
                    size: '20 m2',
                    capacity: 1000,
                    farm_id: farms(:one).id } }
    end

    let(:invalid_params) do
      { storage: { name: '',
                   size: '',
                   capacity: '',
                   farm_id: '' } }
    end

    context "when user is authenticated" do
      it "creates a new storage with valid parameters" do
        expect { post :create, params: valid_params }.to change(Storage, :count).by(1)
      end

      it "redirects to storages_path after creating a new storage" do
        post :create, params: valid_params
        expect(response).to redirect_to(storages_path)
      end

      it "does not create a new storage with invalid parameters" do
        expect { post :create, params: invalid_params }.not_to change(Storage, :count)
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
    it "updates the storage" do
      put :update, params: { id: storages(:one).id, storage: { name: "Updated storage" } }
      expect(response).to redirect_to(storages_path)
    end
  end

  describe "DELETE destroy" do
    it "deletes the storage" do
      delete :destroy, params: { id: storages(:one).id }
      expect(response).to redirect_to(storages_path)
    end
  end
end
