require "rails_helper"

RSpec.describe "Activity flow", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :farms, :activities, :employees, :chemicals

  before do
    sign_in users(:henrique)
  end

  describe "creating an activity with chemical and responsible" do
    it "persists the complete activity flow" do
      expect {
        post activities_path, params: {
          activity: {
            description: "Plantio de milho",
            activity_type: "Plantio",
            area: "Campo",
            place: "Talhão 1",
            resources: "Trator",
            farm_id: farms(:one).id
          },
          date_start: Date.current,
          date_end: Date.current + 7.days
        }
      }.to change(Activity, :count).by(1)

      activity = Activity.last

      expect(response).to redirect_to(activity_path(activity))

      expect(activity.farm).to eq(farms(:one))
      expect(activity.description).to eq("Plantio de milho")
      expect(activity.forecast_days).to eq(8)

      expect {
        post activity_activity_chemicals_path(activity), params: {
          activity_chemical: {
            chemical_id: chemicals(:one).id,
            quantity: 5
          }
        }
      }.to change(ActivityChemical, :count).by(1)

      expect(response).to redirect_to(activity_path(activity))

      activity_chemical = activity.activity_chemicals.last

      expect(activity_chemical.chemical).to eq(chemicals(:one))
      expect(activity_chemical.quantity).to eq(5)

      expect {
        post activity_responsibles_path(activity), params: {
          responsible: {
            employee_id: employees(:one).id,
            activity_id: activity.id
          }
        }
      }.to change(Responsible, :count).by(1)

      expect(response).to redirect_to(activity_path(activity))

      responsible = activity.responsibles.last

      expect(responsible.employee).to eq(employees(:one))
      expect(responsible.name).to eq(employees(:one).user.full_name)
    end
  end

  describe "adding an invalid chemical to an activity" do
    it "does not persist the activity chemical" do
      activity = Activity.create!(
        farm: farms(:one),
        description: "Plantio de milho",
        activity_type: "Plantio",
        area: "Campo",
        resources: "Trator",
        date_start: Date.current,
        date_end: Date.current + 7.days
      )

      expect {
        post activity_activity_chemicals_path(activity), params: {
          activity_chemical: {
            chemical_id: chemicals(:one).id,
            quantity: 0
          }
        }
      }.not_to change(ActivityChemical, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(activity.reload).to be_persisted
      expect(activity.activity_chemicals).to be_empty
    end
  end
end
