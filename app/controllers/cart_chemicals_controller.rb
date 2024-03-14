class CartChemicalsController < ApplicationController
  def new
    @cart_chemical = CartChemical.new
    authorize @cart_checimal
    @cart = Cart.find(params[:id])
    @chemicals = Chemical.all
  end

  def create
    @cart_chemical = CartChemical.new(cart_chemical_params)
    authorize @cart_chemical
    @cart = Cart.find(params[:cart_id])
    @cart_chemical.cart = @cart

    @cart_chemicals = @cart.cart_chemicals
    @chemicals = Chemical.all.order(product_name: :asc)
    existing_chemical_ids = @cart.cart_chemicals.pluck(:chemical_id)
    @erro = false
    # Remover os chemicals já presentes na lista de chemicals disponíveis
    @chemicals = @chemicals.where.not(id: existing_chemical_ids)
    if params[:cart_chemical][:entry] == "0"
      @cart_chemical.quantity = -@cart_chemical.quantity
    end
    if @cart_chemical.save
      redirect_to cart_path(@cart, entry: params[:cart_chemical][:entry])
    else
      render 'carts/show', status: :unprocessable_entity
    end
  end

  def destroy
    @cart_chemical = CartChemical.find(params[:id])
    authorize @cart_chemical
    @cart_chemical.destroy
    flash[:alert] = "Item excluído com sucesso."

    redirect_to cart_path(@cart_chemical.cart, entry: params[:entry])
  end
  private

  def cart_chemical_params
    params.require(:cart_chemical).permit(:quantity, :chemical_id, :entry)
  end
end
