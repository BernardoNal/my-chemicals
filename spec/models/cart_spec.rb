require 'rails_helper'

RSpec.describe Cart, :type => :model do
  fixtures :storages,:users
  context "Validar cart" do

    it "cart ok" do
      storage = storages(:one)
      user = users(:henrique)
      cart = Cart.new( requestor_id:user.id, approver_id:user.id, storage_id: storage.id)
      expect(cart).to be_valid
    end
    it "erro na cart" do
      cart = Cart.new()
      expect(cart).to_not be_valid
    end
  end
end
