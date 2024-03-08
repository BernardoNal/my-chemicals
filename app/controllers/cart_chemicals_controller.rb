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

   if @cart_chemical.save
     # redirect_to product_path(@product)
   else
     render :new, status: :unprocessable_entity
   end
  end


  private

  def cart_chemical_params
    params.require(:cart_chemical).permit(:quantity, :chemical_id)
  end
end
