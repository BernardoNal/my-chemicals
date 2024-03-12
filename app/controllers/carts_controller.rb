class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @carts = policy_scope(Cart)
  end

  def new
    @storage = Storage.find(params[:format])
    @chemicals = Chemical.all
    @cart = Cart.new
    authorize @cart
    @cart.storage = @storage
    @cart.save
    @cart_chemical = CartChemical.new
  end

  def create
    Cart.where(storage_id: params[:storage_id]).destroy_by(approved: nil)
    @cart = Cart.new
    @storage = Storage.find(params[:storage_id])
    @cart.storage = @storage
    authorize @cart
    if @cart.save
      redirect_to cart_path(@cart, entry: params[:cart][:entry])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @entry = params[:entry]
    @cart = Cart.find(params[:id])
    authorize @cart
    @cart_chemical = CartChemical.new
    @chemicals = Chemical.all
    existing_chemical_ids = @cart.cart_chemicals.pluck(:chemical_id)
    # Remover os chemicals já presentes na lista de chemicals disponíveis
    @chemicals = @chemicals.where.not(id: existing_chemical_ids)
    @cart_chemicals = @cart.cart_chemicals
  end

  def record
    @cart = Cart.find(params[:id])
    authorize @cart
    if @cart.cart_chemicals != []
      @cart.date_move = Time.now
      @cart.approved = true
      if @cart.save
        redirect_to farms_path(farm_id: @cart.storage.farm_id,storage_id: @cart.storage_id)
      else
        render :new, status: :unprocessable_entity
      end
    end

  end

  def destroy
    @cart = Cart.find(params[:id])
    authorize @cart
    @cart.destroy!

    redirect_to farms_path
  end
end
