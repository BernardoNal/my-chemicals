RSpec.describe Employee, :type => :model do
  # Load necessary fixtures for the tests
  fixtures :users, :farms
  let(:valid_attributes) do
    {
      farm_id: farms(:one).id,
      user_id: users(:henrique).id,
      user_cpf: '90236213016'
    }
  end

  context "Employee validation" do
    # Test if an employee is valid with all correct attributes
    it "valid employee" do
      farm = farms(:one)
      employee = Employee.new(valid_attributes)
      expect(employee).to be_valid
    end
  end

  context "Employee errors" do

    before do
      @employee = Employee.new(valid_attributes)
    end

    # Test each attribute for presence validation
    %i[farm_id user_id].each do |attr|
      it "blank #{attr}" do
        @employee[attr] = nil
        @employee.valid?
        expect(@employee.errors[attr]).to include("can't be blank")
      end
    end

    # Test if the user_cpf attribute is blank
    it "blank user_cpf" do
      @employee.user_cpf = nil
      @employee.valid?
      expect(@employee.errors[:user_cpf]).to include("can't be blank")
    end

    # Test if the user_cpf attribute is invalid
    it "invalid cpf" do
      @employee.user_cpf = '79143178'
      @employee.valid?
      expect(@employee.errors[:user_cpf]).to include("Inválido")
    end

    # Test if the cpf is not registered
    it "cpf not registered" do
      @employee.user_cpf = '94268800549'
      @employee.valid?
      expect(@employee.errors[:user_cpf]).to include("não cadastrado")
    end

    # Test if the cpf is already associated with another user
    it "cpf self registration" do
      @employee.user_cpf = '79143178880'
      @employee.valid?
      expect(@employee.errors[:user_cpf]).to include("não é possível se cadastrar")
    end
  end
end
