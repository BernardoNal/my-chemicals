require "rails_helper"

RSpec.describe "Employee flow", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :farms, :employees

  before do
    sign_in users(:henrique)
  end

  describe "creating and deleting an employee" do
    it "persists and then removes the employee" do
      expect {
        post employees_path, params: {
          employee: {
            farm_id: farms(:one).id,
            user_cpf: users(:rogerio).cpf,
            manager: false
          }
        }
      }.to change(Employee, :count).by(1)

      employee = Employee.last

      expect(response).to redirect_to(employees_path)
      expect(employee.farm).to eq(farms(:one))
      expect(employee.user).to eq(users(:rogerio))
      expect(employee.manager).to be(false)

      expect {
        delete employee_path(employee)
      }.to change(Employee, :count).by(-1)

      expect(response).to redirect_to(employees_path)
      expect(Employee.exists?(employee.id)).to be(false)
    end
  end

  describe "creating a duplicate employee" do
    it "does not persist another employee for the same farm and user" do
      expect {
        post employees_path, params: {
          employee: {
            farm_id: farms(:one).id,
            user_cpf: users(:carlos).cpf,
            manager: false
          }
        }
      }.not_to change(Employee, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(Employee.where(
        farm: farms(:one),
        user: users(:carlos)
      ).count).to eq(1)
    end
  end

end
