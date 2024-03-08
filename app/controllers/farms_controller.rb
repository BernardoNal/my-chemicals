class FarmsController < ApplicationController
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
