require 'rails_helper'

RSpec.describe Storage, :type => :model do
  fixtures :farms
  context "Validar galpão" do

    it "galpão ok" do
      farm = farms(:one)
      storage = Storage.new(name: "Galpão principal", size: '20 m2', capacity: 1000, farm_id: farm.id)
      expect(storage).to be_valid
    end
    it "erro na galpão" do
      storage = Storage.new(name: "Galpão principal", size: '20 m2', capacity: 1000)
      expect(storage).to_not be_valid
    end
  end
end
