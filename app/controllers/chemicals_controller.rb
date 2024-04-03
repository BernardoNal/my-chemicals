class ChemicalsController < ApplicationController
  # Displays details of a specific chemical
  def show
    @chemical = Chemical.find(params[:id])
    authorize @chemical
  end
end
