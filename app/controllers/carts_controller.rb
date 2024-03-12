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
    @cart_chemicals = @cart.cart_chemicals
  end

  def record
    @cart = Cart.find(params[:id])
    @cart.date_move = Time.now
    @cart.approved = true
    authorize @cart
    if @cart.save
      redirect_to farms_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @cart = Cart.find(params[:id])
    authorize @cart
    @cart.destroy!

    redirect_to farms_path
  end
end
