class EmployeesController < ApplicationController
  # Displays a list of farms accessible to the current user
  def index
    @farms = policy_scope(Farm)
    @user = current_user
  end

  # Prepares a form to create a new employee
  def new
    @employee = Employee.new
    authorize @employee
    @farms = current_user.farms
    @users = User.all
  end

  # Creates a new employee record
  def create
    @employee = Employee.new(employee_params)
    @farms = current_user.farms
    @employee.user = User.find_by(cpf: @employee.user_cpf)
    @employee.invite = false
    authorize @employee
    p @employee
    @employee.valid?
    p @employee.errors
    if @employee.save
      redirect_to employees_path
      flash[:alert] = "Convite enviado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Displays a list of current user's jobs
  def myjobs
    @employees = current_user.employees
    authorize @employees
  end

  # Updates an employee record to mark as invited
  def update
    @employee = Employee.find(params[:id])
    @employee.user_cpf = @employee.user.cpf
    @employee.invite = true
    authorize @employee
    if @employee.save
      redirect_to myjobs_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Deletes an employee record
  def destroy
    @employee = Employee.find(params[:id])
    authorize @employee
    @employee.destroy
    flash[:alert] = "Funcionario removido com sucesso."

    redirect_to employees_path
  end

  private

  # Defines permitted parameters for creating or updating an employee
  def employee_params
    params.require(:employee).permit(:manager, :farm_id, :user_cpf)
  end
end
