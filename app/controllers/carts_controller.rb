class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @carts = policy_scope(Cart)
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @carts = @carts.where(date_move: start_date..end_date)
    end
    @carts = @carts.all.group_by(&:date_move)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = CartPdf.new(@carts).call
        send_data pdf, filename: "carts_report.pdf", type: "application/pdf"
      end
    end
  end

  def pending
    @carts = policy_scope(Cart).where(approved: false)
    authorize @carts
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
    @chemicals = Chemical.all.order(product_name: :asc)
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
      manager = @cart.storage.farm.employees.find_by(user_id: current_user.id)
      @cart.approved = (manager.present? && manager.manager) || @cart.storage.farm.user == current_user ? true : false
      if @cart.save
        redirect_to farms_path(farm_id: @cart.storage.farm_id, storage_id: @cart.storage_id)
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
