class ResponsiblesController < ApplicationController
  # Displays a list of farms accessible to the current user
  # def index
  #   @farms = policy_scope(Farm)
  #   @user = current_user
  # end

  # # Prepares a form to create a new responsible
  # def new
  #   @responsible = Responsible.new
  #   authorize @responsible
  # end

  # Creates a new responsible record
  def create
    @activity_chemical = ActivityChemical.new
    @responsible = Responsible.new(responsible_params)
    @activity = Activity.find(params[:activity_id])
    @chemicals = @activity.available_chemicals
    @employees = @activity.available_responsibles
    @responsible.activity = @activity
    authorize @responsible
    if @responsible.save
      redirect_to activity_path(@activity)
    else
      render 'activities/show', status: :unprocessable_entity
    end
  end


  # Deletes an responsible record
  def destroy
    @responsible = Responsible.find(params[:id])
    authorize @responsible
    @responsible.destroy
    flash[:alert] = "Funcionario removido com sucesso."

    redirect_to activity_path(@responsible.activity)
  end

  private

  # Defines permitted parameters for creating or updating an responsible
  def responsible_params
    params.require(:responsible).permit(:name, :activity_id, :employee_id)
  end
end
