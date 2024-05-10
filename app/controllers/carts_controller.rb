class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: %i[show record destroy]

  # Displays a list of carts within a specified date range
  def index
    Cart.all.each do |cart|
      cart.destroy if cart.cart_chemicals == []
    end
    @carts = policy_scope(Cart).order(updated_at: :desc)
    @chemicals = Chemical.all.order(product_name: :asc)
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current

    @carts = params[:chemical].to_i > 0 ? @carts.joins(cart_chemicals: :chemical)
                    .where(date_move: @start_date..@end_date, cart_chemicals: { chemical_id: params[:chemical] })
                    .group_by(&:date_move) : @carts.where(date_move: @start_date..@end_date).group_by(&:date_move)

    render_pdf
  end

  # Displays a list of pending carts
  def pending
    @carts = policy_scope(Cart).where(approved: false)
    authorize @carts
    current_user.employees.each do |employee|
      if employee.manager
        employee.farm.carts.where(approved: false).each do |cart_aux|
          @carts += [cart_aux]
        end
      end
    end
  end

  # Initializes a new cart
  def new
    @storage = Storage.find(params[:format])
    @chemicals = Chemical.all
    @cart = Cart.new
    authorize @cart
    @cart.storage = @storage
    @cart.save
    @cart_chemical = CartChemical.new
  end

  # Creates a new cart
  def create
    Cart.where(storage_id: params[:storage_id]).destroy_by(approved: nil)
    @cart = Cart.new
    @storage = Storage.find(params[:storage_id])
    set_new_cart
    authorize @cart
    if @cart.save
      redirect_to cart_path(@cart, entry: params[:cart][:entry])
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Displays details of a specific cart
  def show
    @entry = params[:entry]
    @cart = Cart.find(params[:id])
    authorize @cart
    @cart_chemical = CartChemical.new
    exit_chemicals
    @chemicals = @entry == "0" ? @chemicals_exit : Chemical.all.order(product_name: :asc)
    existing_chemical_ids = @cart.cart_chemicals.pluck(:chemical_id)
    @chemicals = @chemicals.where.not(id: existing_chemical_ids)
    @cart_chemicals = @cart.cart_chemicals
  end

  # Records a cart
  def record
    @cart = Cart.find(params[:id])
    authorize @cart
    return unless @cart.cart_chemicals != []

    cart_record
    if @cart.save
      CartMailer.with(@cart).create_pendence.deliver_now unless @cart.approved
      redirect_to farms_path(farm_id: @cart.storage.farm_id, storage_id: @cart.storage_id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Deletes a cart
  def destroy
    @cart = Cart.find(params[:id])
    authorize @cart
    @cart.destroy!
    redirect_to farms_path
  end

  private

  # Sets the cart instance variable based on the provided id
  def set_cart
    @cart = Cart.find(params[:id])
  end

  # Sets the new cart instance variable
  def set_new_cart
    @cart.storage = @storage
    @cart.requestor_id = current_user.id
    @cart.approver_id = current_user.id
  end

  # Renders a PDF format of the carts list
  def render_pdf
    @one_chemical = params[:chemical].to_i > 0 ? Chemical.find(params[:chemical]) : false
    respond_to do |format|
      format.html
      format.pdf do
        pdf = CartPdf.new(@carts, @one_chemical).call
        send_data pdf, filename: "carts_report.pdf", type: "application/pdf"
      end
    end
  end

  # Processes the cart record
  def cart_record
    @cart.date_move = Time.now
    manager = @cart.storage.farm.employees.find_by(user_id: current_user.id)
    @cart.approved = (manager.present? && manager.manager) || @cart.storage.farm.user == current_user ? true : false
    @cart.approver_id = current_user.id
  end

  # A collection of chemicals with their total exited quantities.
  def exit_chemicals
    @carts = @cart.storage.carts
    @chemicals_exit = Chemical.joins(:cart_chemical)
                              .where(cart_chemicals: { cart_id: @carts.ids })
                              .group('chemicals.id')
                              .having('SUM(cart_chemicals.quantity) > 0')
                              .select('chemicals.*, SUM(cart_chemicals.quantity) AS total_quantity')
                              .order(product_name: :asc)
  end
end
