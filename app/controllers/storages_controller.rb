class StoragesController < ApplicationController
  before_action :set_storage, only: %i[edit update destroy]
  # Displays a list of storages
  def index
    @storages = policy_scope(Storage)
  end

  # Renders form to create a new storage
  def new
    @storage = Storage.new
    authorize @storage
    @farms = current_user.farms
  end

  # Creates a new storage
  def create
    @farms = current_user.farms
    @storage = Storage.new(storage_params)
    authorize @storage
    if @storage.save
      redirect_to storages_path
      flash[:alert] = "Galpão criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Renders form to edit a storage
  def edit
    authorize @storage
  end

  # Updates a storage
  def update
    authorize @storage
    if @storage.update(storage_params)
      redirect_to storages_path
      flash[:alert] = "Galpão atualizado com sucesso."

    else
      render :new, status: :unprocessable_entity
    end
  end

  # Deletes a storage
  def destroy
    authorize @storage
    @storage.destroy
    flash[:alert] = "Galpão excluído com sucesso."

    redirect_to storages_path
  end

  private

  # Permits storage parameters
  def storage_params
    params.require(:storage).permit(:name, :size, :farm_id)
  end

  # Sets the storage instance variable based on the provided id
  def set_storage
    @storage = Storage.find(params[:id])
  end
end
