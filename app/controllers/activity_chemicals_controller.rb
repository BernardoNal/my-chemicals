class ActivityChemicalsController < ApplicationController
    # Renders a form to create a new ActivityChemical
    def new
      @activity_chemical = ActivityChemical.new
      authorize @activity_chemical
      @activity = Activity.find(params[:activity_id])
      @chemicals = Chemical.all
    end

    # Creates a new ActivityChemical
    def create
      @activity_chemical = ActivityChemical.new(activity_chemical_params)
      authorize @activity_chemical
      @activity = Activity.find(params[:activity_id])
      init_activity_chemical
      if @activity_chemical.save
        redirect_to activity_path(@activity)
      else
        render 'activitys/show', status: :unprocessable_entity
      end
    end

    # Deletes a ActivityChemical
    def destroy
      @activity_chemical = ActivityChemical.find(params[:id])
      authorize @activity_chemical
      @activity_chemical.destroy
      flash[:alert] = "Item excluído com sucesso."

      redirect_to activity_path(@activity_chemical.activity)
    end

    private

    # Strong parameters for ActivityChemical
    def activity_chemical_params
      params.require(:activity_chemical).permit(:quantity, :chemical_id)
    end


    # Initializes a new ActivityChemical
    def init_activity_chemical
      @activity_chemical.activity = @activity
      @activity_chemicals = @activity.activity_chemicals
      existing_chemical_ids = @activity.activity_chemicals.pluck(:chemical_id)
      @chemicals = Chemical.all.order(product_name: :asc).where.not(id: existing_chemical_ids)
    end
end
