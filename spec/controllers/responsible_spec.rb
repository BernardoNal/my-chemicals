require "rails_helper"

RSpec.describe ResponsiblesController, type: :controller do
  fixtures :users, :farms, :activities

  before { sign_in users(:henrique) }

  describe "POST create" do
    context "when the activity belongs to another farm" do
      let!(:other_activity) do
        Activity.create!(
          date_start: Date.current,
          date_end: Date.current + 7.days,
          activity_type: "teste",
          area: "campo",
          farm: farms(:two)
        )
      end

      it "redirects to the root path" do
        post :create, params: {
          activity_id: other_activity.id,
          responsible: {
            name: "Unauthorized Responsible",
            activity_id: other_activity.id
          }
        }

        expect(response).to redirect_to(root_path)
      end

      it "does not create the responsible" do
        expect {
          post :create, params: {
            activity_id: other_activity.id,
            responsible: {
              name: "Unauthorized Responsible",
              activity_id: other_activity.id
            }
          }
        }.not_to change(Responsible, :count)
      end
    end
  end

  describe "DELETE destroy" do
    context "when the responsible belongs to another farm" do
      let!(:other_activity) do
        Activity.create!(
          date_start: Date.current,
          date_end: Date.current + 7.days,
          activity_type: "teste",
          area: "campo",
          farm: farms(:two)
        )
      end

      let!(:responsible) do
        Responsible.create!(
          name: "Other Farm Responsible",
          activity: other_activity
        )
      end

      it "redirects to the root path" do
        delete :destroy, params: { id: responsible.id }

        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the responsible" do
        expect {
          delete :destroy, params: { id: responsible.id }
        }.not_to change(Responsible, :count)
      end
    end
  end
end
