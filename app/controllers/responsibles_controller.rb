class ResponsiblesController < ApplicationController
  # Displays a list of farms accessible to the current user
  # def index
  #   @farms = policy_scope(Farm)
  #   @user = current_user
  # end

  # Prepares a form to create a new responsible
  def new
    @responsible = Responsible.new
    authorize @responsible
  end

  # Creates a new responsible record
  def create
    @responsible = Responsible.new(responsible_params)
    @responsible.valid?
    authorize @responsible
    if @responsible.save
      redirect_to responsibles_path
      flash[:alert] = "Convite enviado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end


  # Deletes an responsible record
  def destroy
    @responsible = responsible.find(params[:id])
    authorize @responsible
    @responsible.destroy
    flash[:alert] = "Funcionario removido com sucesso."

    redirect_to responsibles_path
  end

  private

  # Defines permitted parameters for creating or updating an responsible
  def responsible_params
    params.require(:responsible).permit(:activity_id, :employee_id)
  end
end
