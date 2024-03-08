class ChemicalsController < ApplicationController
  def index
    @chemicals = Chemical.all
  end

  def show
    @chemical = Chemical.find(params[:id])
  end
end
