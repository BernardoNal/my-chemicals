require 'rails_helper'

RSpec.describe User, :type => :model do

  # Define valid attributes for user
  let(:valid_attributes) do
    {
      email: "henrique1@email.com",
      password: '123456',
      first_name: 'Henrique',
      last_name: 'Dias',
      cpf: CPF.generate
    }
  end
  context "User  validation" do
    # Test if a user  is valid with all correct attributes
    it "valid user " do
      user = User.new(valid_attributes)
      expect(user).to be_valid
    end
  end
  context "user errors" do
    before do
      @user = User.new(valid_attributes)
    end

    # Test each attribute for presence validation
    %i[email  first_name last_name cpf].each do |attr|
      it "blank #{attr}" do
        @user[attr] = nil
        @user.valid?
        expect(@user.errors[attr]).to include("can't be blank")
      end
    end

     # Test if the password attribute is blank
     it "blank password" do
      @user.password = nil
      @user.valid?
      expect(@user.errors[:password]).to include("can't be blank")
    end

     # Test if the cpf attribute is invalid
     it "invalid cpf" do
      @user.cpf = '79143178'
      @user.valid?
      expect(@user.errors[:cpf]).to include("Inválido")
    end

  end
end
