class FarmsController < ApplicationController
  def new
    @farm = Farm.new
  end

  def create
    @farm = Farm.new(farm_params)
    @farm.user = current_user
    @farm.save

    if @farm.save
      # redirect_to product_path(@product)
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
