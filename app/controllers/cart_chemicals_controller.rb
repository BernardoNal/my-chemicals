class CartChemicalsController < ApplicationController

  # Creates a new CartChemical
  def create
    @cart_chemical = CartChemical.new(cart_chemical_params)
    authorize @cart_chemical
    @cart = Cart.find(params[:cart_id])
    init_cart_chemical
    chemical_exit
    if @cart_chemical.save
      redirect_to cart_path(@cart, entry: params[:cart_chemical][:entry])
    else
      @entry = params[:cart_chemical][:entry]
      render 'carts/show', status: :unprocessable_entity
    end
  end

  # Deletes a CartChemical
  def destroy
    @cart_chemical = CartChemical.find(params[:id])
    authorize @cart_chemical
    @cart_chemical.destroy
    flash[:alert] = "Item excluído com sucesso."

    redirect_to cart_path(@cart_chemical.cart, entry: params[:entry])
  end

  private

  # Strong parameters for CartChemical
  def cart_chemical_params
    params.require(:cart_chemical).permit(:quantity, :chemical_id, :entry)
  end

  # Checks if the entry is an exit and sets quantity as negative
  def chemical_exit
    return unless params[:cart_chemical][:entry] == "0" && @cart_chemical.quantity

    @cart_chemical.quantity = -@cart_chemical.quantity
  end

  # Initializes a new CartChemical
  def init_cart_chemical
    @cart_chemical.cart = @cart
    @cart_chemicals = @cart.cart_chemicals
    existing_chemical_ids = @cart.cart_chemicals.pluck(:chemical_id)
    @chemicals = Chemical.all.order(product_name: :asc).where.not(id: existing_chemical_ids)
  end
end
