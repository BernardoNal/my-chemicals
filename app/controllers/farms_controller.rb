class FarmsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show storages]

  def index
    @farms = Farm.includes(:storages)
    @carts = Cart.all
    respond_to do |format|
      format.html
      format.json { render json: @farms.as_json(include: :storages) }
    end
  end

  def show
    @farm = Farm.find(params[:id])
    @storages = @farm.storages
  end

  def storages
    farm = Farm.find(params[:id])
    @storages = farm.storages
    render json: @storages
  end

  def carts
    @storage = Storage.find(params[:id])
    @carts = @storage.carts
    @chemical_totals = CartChemical.joins(:chemical)
                                   .select('chemicals.product_name, chemicals.type_product, chemicals.compound_product, SUM(cart_chemicals.quantity) as total_quantity')
                                   .group('chemicals.product_name, chemicals.type_product, chemicals.compound_product')
    render partial: 'farms/carts', locals: { chemical_totals: @chemical_totals }, formats: [:html]
  end
end
