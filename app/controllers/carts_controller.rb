class CartsController < ApplicationController
  before_action :authenticate_user!

  def new
     raise
    @storage = Storage.find(params[:format])
    @chemicals = Chemical.all
    @cart = Cart.new
    @cart.storage = @storage
    @cart.save
    @cart_chemical = CartChemical.new
  end

  def create
    @cart = Cart.new
    @storage = Storage.find(params[:storage_id])
    @cart.storage = @storage
    if @cart.save
      flash[:alert] = "Fazenda criada com sucesso."

      redirect_to cart_path(@cart)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @cart = Cart.find(params[:id])
    @cart_chemical = CartChemical.new
    @chemicals = Chemical.all
    @cart_chemicals = @cart.cart_chemicals
  end

  def add_chemical_to_cart
    chemical = Chemical.find(params[:chemical_id])
    quantity = params[:quantity].to_i
    @cart = current_cart

    new_item = @cart.cart_items.find_or_initialize_by(chemical: chemical)

    new_item.quantity ||= 0
    new_item.quantity += quantity

    if new_item.quantity > chemical.quantity
      redirect_to chemical_path(chemical), alert: 'Not enough chemical quantity available.'
    elsif new_item.save
      redirect_to cart_path, notice: 'chemical added to cart.'
    else
      redirect_to chemical_path(chemical), alert: 'There was a problem adding the chemical to the cart.'
    end
  end

  def purchase_items
    @cart = current_cart
    insufficient_stock = false

    ActiveRecord::Base.transaction do
      @cart.cart_items.each do |cart_item|
        @chemical = cart_item.chemical
        new_quantity = @chemical.quantity - cart_item.quantity

        if new_quantity.negative?

          insufficient_stock = true
          raise ActiveRecord::Rollback
        end

        @chemical.update!(quantity: new_quantity)
        Purchase.create!(user: current_user, chemical: @chemical, quantity: cart_item.quantity, date_purchase: Time.zone.now)
      end
      @cart.destroy!
    end

    if insufficient_stock

      flash[:alert] = 'Sorry, there was not enough stock for one or more chemicals.'
      redirect_to cart_path
    else

      session[:cart_id] = nil

      redirect_to mypurchases_path, notice: 'Thank you for your purchase!'
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Purchase failed due to validation error: #{e.message}")
    flash[:alert] = 'Sorry, there was a problem with your purchase.'
    redirect_to cart_path
  end

  def destroy
    @cart = current_cart
    if @cart
      @cart.destroy
      session[:cart_id] = nil
      redirect_to root_path, notice: 'Cart emptied successfully.'
    else
      redirect_to root_path, alert: 'No cart found to empty.'
    end
  end

  private

  def current_cart
    current_user.cart ||= Cart.create(user: current_user)
  end
end
