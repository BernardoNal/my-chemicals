class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show edit update destroy]
  # Displays a list of activities
  def index
    @activities = policy_scope(Activity)
    # @farms = Farm.all
  end

  # Displays details of a specific activity
  def show
    authorize @activity
    @activity_chemical = ActivityChemical.new
    @responsible = Responsible.new
    @chemicals = @activity.available_chemicals
    @employees = @activity.available_responsibles
  end

  # Renders form to create a new activity
  def new
    @activity = Activity.new
    authorize @activity
    @farms = current_user.farms
  end

  # Creates a new activity
  def create
    @farms = current_user.farms
    @activity = Activity.new(activity_params)
    set_datas
    authorize @activity
    if @activity.save
      redirect_to activity_path(@activity)
      flash[:alert] = "Atividade criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Renders form to edit a activity
  def edit
    authorize @activity
    @farms = current_user.farms
  end

  # Updates a activity
  def update
    set_datas
    authorize @activity
    if @activity.update(activity_params)
      redirect_to activity_path(@activity)
      flash[:alert] = "Atividade atualizada com sucesso."

    else
      render :new, status: :unprocessable_entity
    end
  end

  # Deletes a activity
  def destroy
    authorize @activity
    @activity.destroy
    flash[:alert] = "Atividade excluída com sucesso."

    redirect_to farm_activities_path(@activity.farm)
  end

  private

  # Permits activity parameters
  def activity_params
    params.require(:activity).permit(:name, :description, :activity_type, :area, :place, :resources, :farm_id,)
  end

  # Sets the activity instance variable based on the provided id
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_datas
    @activity.date_start =params[:date_start]
    @activity.date_end = params[:date_end]
  end

  def filter
    case params[:filter]
    when "1"
      @activities = @activities.order(name: :asc)
    when "2"
      @activities = @activities.order(activity_type: :desc)
    when "3"
      @activities = @activities.order(date_start: :asc)
    else
      @activities = @activities.order(date_end: :desc)
    end
  end
end
