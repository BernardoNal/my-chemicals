class ChemicalsController < ApplicationController
  # Displays details of a specific chemical
  def show
    @chemical = Chemical.find(params[:id])
    authorize @chemical
  end

  def new
    @chemical = Chemical.new
    authorize @chemical
  end

  # Creates a new chemical
  def create
    @chemical = Chemical.new(chemical_params)
    authorize @chemical
    if @chemical.save
      flash[:alert] = "Químico criado com sucesso."

      redirect_to root_path
      # redirect_to mychemicals_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Permits chemical parameters
  def chemical_params
    params.require(:chemical).permit(:product_name, :compound_product, :type_product, :area, :measurement_unit, :amount)
  end
end
