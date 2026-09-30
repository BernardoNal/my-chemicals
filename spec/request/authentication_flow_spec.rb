require "rails_helper"

RSpec.describe "Authentication flow", type: :request do
  let!(:user) do
    User.create!(
      email: "authentication@example.com",
      password: "123456",
      first_name: "Authentication",
      last_name: "User",
      cpf: CPF.generate
    )
  end

  describe "logging in" do
    it "authenticates the user with valid credentials" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "123456"
        }
      }

      expect(response).to redirect_to(root_path)

      get myfarms_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "logging out" do
    it "ends the authenticated session" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "123456"
        }
      }

      expect(response).to redirect_to(root_path)

      delete destroy_user_session_path

      expect(response).to redirect_to(root_path)

      get myfarms_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "accessing a protected page without authentication" do
    it "redirects the user to the login page" do
      get myfarms_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
