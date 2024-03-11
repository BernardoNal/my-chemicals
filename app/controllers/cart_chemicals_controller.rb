class CartChemicalsController < ApplicationController
  def new
    @cart_chemical = CartChemical.new
    @cart = Cart.find(params[:id])
    @chemicals = Chemical.all
  end

  def create
    @cart_chemical = CartChemical.new(cart_chemical_params)
    @cart = Cart.find(params[:cart_id])
    @cart_chemical.cart = @cart
    if params[:cart_chemical][:entry] == "0"
      @cart_chemical.quantity = -@cart_chemical.quantity
      @chemical_totals = CartChemical.joins(:chemical, :cart)
      .where(chemical: Chemical.find(params[:cart_chemical][:chemical_id]))
      .where(cart: { approved: true })
      .where(cart: { storage_id: @cart.storage_id })
      .sum(:quantity)
      if @chemical_totals < - @cart_chemical.quantity
        flash[:alert] = "Estoque insuficiente." #melhorar esse condição
        render js: "window.location.reload()"
      elsif@cart_chemical.save
        redirect_to cart_path(@cart, entry: params[:cart_chemical][:entry])
      end
    elsif @cart_chemical.save
      redirect_to cart_path(@cart, entry: params[:cart_chemical][:entry])
    end
  end

  def destroy
    @cart_chemical = CartChemical.find(params[:id])
    @cart_chemical.destroy
    flash[:alert] = "Item excluído com sucesso."

    redirect_to cart_path(@cart_chemical.cart)
  end
  private

  def cart_chemical_params
    params.require(:cart_chemical).permit(:quantity, :chemical_id)
  end
end
