class EmployeesController < ApplicationController
  def index
    @farms = policy_scope(Farm)
    @user = current_user
  end

  def new
    @employee = Employee.new
    authorize @employee
    @farms = current_user.farms
    @users = User.all
  end

  def create
    @employee = Employee.new(employee_params)
    @user = User.find_by(cpf: params[:employee][:user_cpf])
    @employee.user = @user
    @employee.invite = false
    # 66699966678
    authorize @employee
    if @employee.save
      redirect_to employees_path
      flash[:alert] = "Convite enviado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def myjobs
    @employees = current_user.employees
    authorize @employees
  end

  def update
    @employee = Employee.find(params[:id])
    @employee.invite = true
    authorize @employee
    if @employee.save
      redirect_to myjobs_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  def destroy
    @employee = Employee.find(params[:id])
    authorize @employee
    @employee.destroy
    flash[:alert] = "Funcionario removido com sucesso."

    redirect_to employees_path
    # render :new, status: :unprocessable_entity
  end

  private

  def employee_params
    params.require(:employee).permit(:manager, :farm_id)
  end
end
