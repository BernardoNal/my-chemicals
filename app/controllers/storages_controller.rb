class StoragesController < ApplicationController
  def index
    @storages = Storage.all
    @farms = Farm.all
  end

  def new
    @storage = Storage.new
  end

  def create
    @farm = Farm.find(params[:farm_id])
    @storage = Storage.new(storage_params)
    @storage.farm = @farm
    if @storage.save
      redirect_to my_storages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @storage = Storage.find(params[:id])
  end

  def update
    @storage = Storage.find(params[:id])
    if @storage.update(storage_params)
      redirect_to my_storages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def my_storages
    @storages = current_user.storages
  end

  def destroy
    @storage = Storage.find(params[:id])
    @storage.destroy

    redirect_to my_storages_path
  end

  private

  def storage_params
    params.require(:storage).permit(:name, :size, :capacity)
  end
end
