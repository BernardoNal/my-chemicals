class FarmsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show storages]
  before_action :set_farm, only: %i[edit update destroy]

  # Displays a list of farms
  def index
    @farms = policy_scope(Farm)
    current_user.employees.each do |employee|
      @farms += [employee.farm] if employee.invite
    end
    @storages = []
    farm_select
    storage_select
    search_chemical
    render_pdf
  end

  # Renders form to create a new farm
  def new
    @farm = Farm.new
    authorize @farm
  end

  # Creates a new farm
  def create
    @farm = Farm.new(farm_params)
    @farm.user = current_user
    authorize @farm
    @farm.save

    if @farm.save
      flash[:alert] = "Fazenda criada com sucesso."

      redirect_to myfarms_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Displays farms owned by the current user
  def myfarms
    @farms = policy_scope(Farm)
    authorize @farms
  end

  # Renders form to edit a farm
  def edit
    authorize @farm
  end

  # Updates a farm
  def update
    authorize @farm
    @farm.update(farm_params)
    flash[:alert] = "Fazenda editada com sucesso."

    redirect_to myfarms_path
  end

  # Deletes a farm
  def destroy
    authorize @farm
    @farm.destroy
    flash[:alert] = "Fazenda excluída com sucesso."

    redirect_to myfarms_path
  end

  private

  # Permits farm parameters
  def farm_params
    params.require(:farm).permit(:name, :size, :cep, :complement, :latitude, :longitude)
  end

  # Sets the farm instance variable based on the provided id
  def set_farm
    @farm = Farm.find(params[:id])
  end

  # Selects a farm
  def farm_select
    return unless params[:farm_id].present?

    @farm = Farm.find(params[:farm_id])
    @storages = @farm.storages
  end

  # Selects a storage
  def storage_select
    return unless params[:storage_id].present?

    @storage = Storage.find(params[:storage_id])
    @carts = @storage.carts
    @cart = Cart.new
    @chemical_totals = Chemical.joins(:cart_chemical)
                               .where(cart_chemicals: { cart_id: @carts.ids })
                               .group('chemicals.id')
                               .having('SUM(cart_chemicals.quantity) > 0')
                               .select('chemicals.*, SUM(cart_chemicals.quantity) AS total_quantity')
                               .order(product_name: :asc)
  end

  # Searches for chemicals
  def search_chemical
    if params[:search].present? && params[:search][:query].present?
      search_query = params[:search][:query]
      chemical_ids = Chemical.search_by_name(search_query).pluck(:id)
      @carts = @carts.joins(:chemicals).where(chemicals: { id: chemical_ids })
    elsif @carts.nil?
      # @carts = Cart.all
    end
  end

  # Renders a PDF format of the chemical table
  def render_pdf
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ChemicalsPdf.new(@chemical_totals, @storage).call
        send_data pdf, filename: "chemicals_report.pdf", type: "application/pdf"
      end
    end
  end

end
