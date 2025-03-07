class ActivityChemicalsController < ApplicationController
    # Renders a form to create a new ActivityChemical

    # Creates a new ActivityChemical
    def create
      @responsible = Responsible.new
      @activity_chemical = ActivityChemical.new(activity_chemical_params)
      authorize @activity_chemical
      @activity = Activity.find(params[:activity_id])
      @chemicals = @activity.available_chemicals
      @employees = @activity.available_responsibles
      @activity_chemical.activity = @activity
      if @activity_chemical.save
        redirect_to activity_path(@activity)
      else
        render 'activities/show', status: :unprocessable_entity
      end
    end

    # Deletes a ActivityChemical
    def destroy
      @activity_chemical = ActivityChemical.find(params[:id])
      authorize @activity_chemical
      @activity_chemical.destroy
      flash[:alert] = "Químico excluído com sucesso."

      redirect_to activity_path(@activity_chemical.activity)
    end

    private

    # Strong parameters for ActivityChemical
    def activity_chemical_params
      params.require(:activity_chemical).permit(:quantity, :chemical_id)
    end

end
