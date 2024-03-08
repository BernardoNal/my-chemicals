class FarmsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show storages]

  def index
    @farms = Farm.all
  end

  def show
    @farm = Farm.find(params[:id])
  end

  def storages
    farm = Farm.find(params[:id])
    @storages = farm.storages
    render json: @storages
  end

  def carts
    @storage = Storage.find(params[:id])
    @carts = @storage.carts

    @chemical_totals = CartChemical.joins(:chemical).where(cart: @carts).group_by(&:chemical_id)
    render partial: 'farms/carts', locals: { chemical_totals: @chemical_totals }, formats: [:html]
  end

  def new
    @farm = Farm.new
  end

  def create
    @farm = Farm.new(farm_params)
    @farm.user = current_user
    @farm.save

    if @farm.save
      redirect_to farm_path(@farm), notice: 'Farm was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def myfarms
    @farms = current_user.farms
  end

  def edit
    @farm = Farm.find(params[:id])
  end

  def update
    @farm = Farm.find(params[:id])
    @farm.update(farm_params)
    flash[:alert] = "Fazenda Editada com sucesso."
    redirect_to farms_path
  end

  def destroy
    @farm = Farm.find(params[:id])
    @farm.destroy

    redirect_to farms_path, notice: 'Fazenda excluída com sucesso.'
  end

  private

  def farm_params
    params.require(:farm).permit(:name, :size, :cep, :complement, :latitude, :longitude)
  end
end
