require 'rails_helper'

RSpec.describe Activity, type: :model do
  # Load necessary fixtures for the tests
  fixtures :farms

  let(:valid_attributes) do
    {
      date_start: Date.today,
      date_end: Date.tomorrow,
      name: "Plantio de Milho",
      activity_type: "teste",
      area: "campo",
      farm_id: farms(:one).id
    }
  end

  context "Activity validation" do
    it "valid activity" do
      activity = Activity.new(valid_attributes)
      expect(activity).to be_valid
    end
  end

  context "Activity errors" do
    before do
      @activity = Activity.new(valid_attributes)
    end

    %i[ name farm_id].each do |attr|
      it "blank #{attr}" do
        @activity[attr] = nil
        @activity.valid?
        expect(@activity.errors[attr]).to include("can't be blank")
      end
    end

    it "date_start must be before date_end" do
      @activity.date_start = Date.tomorrow
      @activity.date_end = Date.today
      @activity.valid?
      expect(@activity.errors[:date_start]).to include("deve ser menor que a data de término")
    end

  end
end
