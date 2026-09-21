require "rails_helper"

RSpec.describe ActivitiesController, type: :controller do
  fixtures :users, :farms, :activities

  before { sign_in users(:henrique) }

  describe "PUT update" do
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
        put :update, params: {
          id: other_activity.id,
          activity: {
            description: "Unauthorized Update"
          }
        }

        expect(response).to redirect_to(root_path)
      end

      it "does not update the activity" do
        expect {
          put :update, params: {
            id: other_activity.id,
            activity: {
              description: "Unauthorized Update"
            }
          }
        }.not_to change { other_activity.reload.description }
      end
    end
  end
end
