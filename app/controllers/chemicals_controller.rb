class ChemicalsController < ApplicationController
  before_action :set_chemical, only: %i[edit update destroy]

  def index
    @chemicals = policy_scope(Chemical).limit(20)
    authorize @chemicals
    if params[:product_name].present?
      @chemicals = @chemicals.where('product_name ILIKE ?', "%#{params[:product_name]}%")
    end
  end

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

      redirect_to chemicals_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Renders form to edit a chemical
  def edit
    authorize @chemical
  end

  # Updates a chemical
  def update
    authorize @chemical
    if @chemical.update(chemical_params)
      flash[:alert] = "Químico Alterado com sucesso."

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

  # Sets the chemical instance variable based on the provided id
  def set_chemical
    @chemical = Chemical.find(params[:id])
  end
end
