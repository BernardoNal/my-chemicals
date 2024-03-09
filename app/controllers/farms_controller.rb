class FarmsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ show storages]

  def index
    @farms = current_user.farms
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
    @cart = Cart.new
    @chemical_totals = CartChemical.joins(:chemical, :cart)
    .where(cart: { approved: true })
    .where(cart: @carts)
    .group_by(&:chemical_id)
    render partial: 'farms/carts', locals: { chemical_totals: @chemical_totals, storage: @storage, cart: @cart}, formats: [:html]
  end

  def new
    @farm = Farm.new
  end

  def create
    @farm = Farm.new(farm_params)
    @farm.user = current_user
    @farm.save

    if @farm.save
      flash[:alert] = "Fazenda criada com sucesso."

      redirect_to myfarms_path
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
    flash[:alert] = "Fazenda editada com sucesso."

    redirect_to myfarms_path
  end

  def destroy
    @farm = Farm.find(params[:id])
    @farm.destroy
    flash[:alert] = "Fazenda excluída com sucesso."

    redirect_to myfarms_path
  end

  private

  def farm_params
    params.require(:farm).permit(:name, :size, :cep, :complement, :latitude, :longitude)
  end
end
