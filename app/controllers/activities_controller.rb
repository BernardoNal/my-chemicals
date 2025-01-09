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
    authorize @activity
    if @activity.save
      redirect_to activities_path(@activity.farm)
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
    authorize @activity
    if @activity.update(activity_params)
      redirect_to farm_activities_path(@activity.farm)
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
    params.require(:activity).permit(:name, :activity_type, :date_start, :date_end, :description, :farm_id)
  end

  # Sets the activity instance variable based on the provided id
  def set_activity
    @activity = Activity.find(params[:id])
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
