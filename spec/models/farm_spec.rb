require 'rails_helper'

RSpec.describe Farm, :type => :model do
  fixtures :users
  context "Validar fazenda" do

    it "fazenda ok" do
     user = users(:henrique)
      farm = Farm.new(name: 'Sol Nascente', size: '500 ha', cep: '49075220', user_id: user.id)
      expect(farm).to be_valid
    end
    it "erro na fazenda" do
      farm = Farm.new(name: 'Sol Nascente', size: '500 ha', cep: '49075220')
      expect(farm).to_not be_valid
    end
  end
end
