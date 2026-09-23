require 'rails_helper'

RSpec.describe EmployeesController, type:  :controller do
  fixtures :employees, :users, :farms
  before { sign_in users(:henrique) }

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
      { employee: { farm_id: farms(:one).id,
                    manager: false,
                    user_cpf: '56974952007',
                    invite: false } }
    end

    let(:invalid_params) do
      { employee: { farm_id: nil,
                    manager: nil,
                    user_cpf: ''} }
    end

    context "when user is authenticated" do
      it "creates a new employee with valid parameters" do
        expect {
          post :create, params: valid_params
        }.to change(Employee, :count).by(1)
      end

      it "redirects to employees_path after creating a new employee" do
        post :create, params: valid_params
        expect(response).to redirect_to(employees_path)
      end

      it "does not create a new employee with invalid parameters" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Employee, :count)
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
  describe "GET myjobs" do
    it "returns a 200" do
      get :myjobs
      expect(response).to have_http_status(200)
      expect(response).to render_template(:myjobs)
    end
  end


  describe "PUT update" do
    context "when the employee belongs to another farm" do
     let(:other_employee) { employees(:three) }

      it "redirects to the root path" do
        put :update, params: { id: other_employee.id }

        expect(response).to redirect_to(root_path)
      end

      it "does not update the employee" do
        expect {
          put :update, params: { id: other_employee.id }
        }.not_to change { other_employee.reload.invite }
      end
    end
  end

  describe "DELETE destroy" do
    context "when the employee belongs to another farm" do
      let(:other_employee) { employees(:three) }

      it "redirects to the root path" do
        delete :destroy, params: { id: other_employee.id }

        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the employee" do
        expect {
          delete :destroy, params: { id: other_employee.id }
        }.not_to change(Employee, :count)
      end
    end
  end
end
