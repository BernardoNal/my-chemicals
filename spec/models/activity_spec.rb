require 'rails_helper'

RSpec.describe Activity, type: :model do
  # Load necessary fixtures for the tests
  fixtures :farms, :activities, :chemicals, :activity_chemicals, :employees

  let(:valid_attributes) do
    {
      date_start: Date.today,
      date_end: Date.tomorrow,
      description: "Plantio de Milho",
      activity_type: "teste",
      area: "campo",
      farm_id: farms(:one).id
    }
  end

  context "valid activity" do
    it "accepts a valid activity" do
      activity = Activity.new(valid_attributes)
      expect(activity).to be_valid
    end
  end

  context "forecast_days" do
    before do
      @activity = Activity.new(valid_attributes)
    end

    it "accepts a non-negative integer" do
      @activity.forecast_days = 10

      expect(@activity).to be_valid
    end

    it "accepts zero" do
      @activity.forecast_days = 0

      expect(@activity).to be_valid
    end

    it "rejects negative values" do
      @activity.forecast_days = -1
      @activity.valid?

      expect(@activity.errors.details[:forecast_days]).to include(
        error: :greater_than_or_equal_to,
        value: -1,
        count: 0
      )
    end

    it "rejects non-integer values" do
      @activity.forecast_days = 1.5
      @activity.valid?

      expect(@activity.errors.details[:forecast_days]).to include(
        error: :not_an_integer,
        value: 1.5
      )
    end
  end

  context "forecast days calculation" do
    before do
      @activity = Activity.new(valid_attributes)
    end

    it "calculates forecast_days including both start and end dates" do
      @activity.date_start = Date.new(2026, 9, 10)
      @activity.date_end = Date.new(2026, 9, 15)

      @activity.save!

      expect(@activity.forecast_days).to eq(6)
    end

    it "sets forecast_days to nil when date_start is missing" do
      @activity.date_start = nil

      @activity.save!

      expect(@activity.forecast_days).to be_nil
    end

    it "sets forecast_days to nil when date_end is missing" do
      @activity.date_end = nil

      @activity.save!

      expect(@activity.forecast_days).to be_nil
    end
  end

  context "description and resources length" do
    before do
      @activity = Activity.new(valid_attributes)
    end

    it "accepts description with up to 400 characters" do
      @activity.description = "a" * 400

      expect(@activity).to be_valid
    end

    it "rejects description longer than 400 characters" do
      @activity.description = "a" * 401
      @activity.valid?

      expect(@activity.errors.details[:description]).to include(
        error: :too_long,
        count: 400
      )
    end

    it "accepts resources with up to 400 characters" do
      @activity.resources = "a" * 400

      expect(@activity).to be_valid
    end

    it "rejects resources longer than 400 characters" do
      @activity.resources = "a" * 401
      @activity.valid?

      expect(@activity.errors.details[:resources]).to include(
        error: :too_long,
        count: 400
      )
    end
  end

  context "associations" do
    it "belongs to a farm" do
      association = described_class.reflect_on_association(:farm)

      expect(association.macro).to eq(:belongs_to)
    end

    it "has many responsibles" do
      association = described_class.reflect_on_association(:responsibles)

      expect(association.macro).to eq(:has_many)
    end

    it "has many activity chemicals" do
      association = described_class.reflect_on_association(:activity_chemicals)

      expect(association.macro).to eq(:has_many)
    end

    it "has many chemicals through activity chemicals" do
      association = described_class.reflect_on_association(:chemicals)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:activity_chemicals)
    end
  end

  context "available chemicals" do
    before do
      @activity = activities(:one)
    end

    it "does not include chemicals already associated with the activity" do
      available_chemicals = @activity.available_chemicals

      expect(available_chemicals).not_to include(chemicals(:one))
    end

    it "returns chemicals ordered by product name" do
      available_chemicals = @activity.available_chemicals

      expect(available_chemicals).to eq(
        [chemicals(:two), chemicals(:three)]
      )
    end
  end

  context "available responsibles" do
    before do
      @activity = activities(:one)
      @employee = employees(:one)

      Responsible.create!(
        activity: @activity,
        employee: @employee
      )
    end

    it "does not include employees already associated with the activity" do
      expect(@activity.available_responsibles).not_to include(@employee)
    end

    it "includes employees that are not associated with the activity" do
      expect(@activity.available_responsibles).to include(employees(:two))
    end

    it "does not include employees from another farm" do
      expect(@activity.available_responsibles).not_to include(employees(:three))
    end
  end

  context "date validation" do
    before do
      @activity = Activity.new(valid_attributes)
    end

    it "accepts date_start before date_end" do
      @activity.date_start = Date.new(2026, 9, 10)
      @activity.date_end = Date.new(2026, 9, 15)

      expect(@activity).to be_valid
    end

    it "accepts equal start and end dates" do
      date = Date.new(2026, 9, 10)
      @activity.date_start = date
      @activity.date_end = date

      expect(@activity).to be_valid
    end

    it "rejects date_end before date_start" do
      @activity.date_start = Date.new(2026, 9, 15)
      @activity.date_end = Date.new(2026, 9, 10)

      expect(@activity).not_to be_valid
      expect(@activity.errors[:date_start]).to include(
        "deve ser menor que a data de término"
      )
    end
  end

  context "required attributes" do
    before do
      @activity = Activity.new(valid_attributes)
    end

    %i[ activity_type area farm_id].each do |attr|
      it "rejects blank #{attr}" do
        @activity[attr] = nil
        @activity.valid?
        expect(@activity.errors.details[attr]).to include(
          error: :blank
        )
      end
    end
  end
end
