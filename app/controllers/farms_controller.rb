class FarmsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ show storages]

  def index
    @farms = policy_scope(Farm)
    @storages = []
    if params[:farm_id].present?
      @farm = Farm.find(params[:farm_id])
      @storages = @farm.storages
    end

    if params[:storage_id].present?
      @storage = Storage.find(params[:storage_id])
      @carts = @storage.carts
      @cart = Cart.new
      @chemical_totals = CartChemical.joins(:chemical, :cart)
                                     .where(cart: { approved: true })
                                     .where(cart: @carts)
                                     .group_by(&:chemical_id)
    end
  end

  def new
    @farm = Farm.new
    authorize @farm
  end

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

  def myfarms
    @farms = policy_scope(Farm)
    authorize @farms
  end

  def edit
    @farm = Farm.find(params[:id])
    authorize @farm
  end

  def update
    @farm = Farm.find(params[:id])
    authorize @farm
    @farm.update(farm_params)
    flash[:alert] = "Fazenda editada com sucesso."

    redirect_to myfarms_path
  end

  def destroy
    @farm = Farm.find(params[:id])
    authorize @farm
    @farm.destroy
    flash[:alert] = "Fazenda excluída com sucesso."

    redirect_to myfarms_path
  end

  private

  def farm_params
    params.require(:farm).permit(:name, :size, :cep, :complement, :latitude, :longitude)
  end
end
