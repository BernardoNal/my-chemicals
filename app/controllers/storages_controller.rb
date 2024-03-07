class StoragesController < ApplicationController
  def index
    @storages = Storage.all
  end

  def new
    @storage = Storage.new
  end

  def create
    @storage = Storage.new(storage_params)
    @storage.farm = current_user.farm # FIX IT
    if @storage.save
      redirect_to storages_path(@storage.farm)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @storage = Storage.find(storage_params)
  end

  def update
    @storage = Storage.find(params[:id])
    if @storage.update(storage_params)
      redirect_to storages_path(@storage.farm)  # FIX IT
    else
      render :new, status: :unprocessable_entity
    end
  end

  def delete
    @storage = Storage.find(params[:id])
    @storage.destroy

    redirect_to storages_path(@storage.farm)
  end

  private

  def storage_params
    params.require(:user).permit(:name, :size, :capacity)
  end
end
