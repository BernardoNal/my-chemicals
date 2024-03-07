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

  private

  def farm_params
    params.require(:farm).permit(:name, :size, :complement, :cep)
  end
end
