class FarmsController < ApplicationController
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
