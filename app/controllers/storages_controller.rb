class StoragesController < ApplicationController
  def index
    @storages = policy_scope(Storage)
    @farms = Farm.all
  end

  def new
    @storage = Storage.new
    authorize @storage
    @farms = current_user.farms
  end

  def create
    @storage = Storage.new(storage_params)
    authorize @storage
    if @storage.save
      redirect_to my_storages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @storage = Storage.find(params[:id])
    authorize @storage
  end

  def update
    @storage = Storage.find(params[:id])
    authorize @storage
    if @storage.update(storage_params)
      redirect_to my_storages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @storage = Storage.find(params[:id])
    @storage.destroy

    redirect_to my_storages_path
  end

  private

  def storage_params
    params.require(:storage).permit(:name, :size, :capacity, :farm_id)
  end
end
