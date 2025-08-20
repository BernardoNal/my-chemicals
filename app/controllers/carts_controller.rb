class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: %i[show record destroy]

  # Displays a list of carts within a specified date range
  def index
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current

    @carts = policy_scope(Cart).where(date_move: @start_date..@end_date).order(updated_at: :desc)
    @chemicals = Chemical.joins(:cart_chemicals)
    .where(cart_chemicals: { cart_id: @carts.ids })
    .distinct
    .order(product_name: :asc)

    if params[:chemical].to_i > 0
      @carts = @carts.joins(cart_chemicals: :chemical).where(cart_chemicals: { chemical_id: params[:chemical] })
    end

    @carts = @carts.group_by(&:date_move)

    render_pdf
  end

  # Displays a list of pending carts
  def pending
    base_scope = policy_scope(Cart).where(approved: false)

    managed_farm_ids = current_user.employees
                                  .where(manager: true)
                                  .pluck(:farm_id)

    @carts = base_scope.or(
      Cart.where(approved: false, farm_id: managed_farm_ids)
    )

    authorize @carts
    end

  # Creates a new cart
  def create
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
    authorize @cart
    @cart_chemical = CartChemical.new
    @chemicals = @entry == "0" ? exit_chemicals : Chemical.all.order(product_name: :asc)
    if @cart.cart_chemicals !=[]
      existing_chemical_ids = @cart.cart_chemicals.pluck(:chemical_id)
      @chemicals = @chemicals.where.not(id: existing_chemical_ids)
    end
    @cart_chemicals = @cart.cart_chemicals
  end

  # Records a cart
  def record
    authorize @cart
    return unless @cart.cart_chemicals != []

    cart_record
    if @cart.save
      #currently only works in development
      #CartMailer.with(@cart).create_pendence.deliver_now unless @cart.approved
      redirect_to farms_path(farm_id: @cart.storage.farm_id, storage_id: @cart.storage_id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Deletes a cart
  def destroy
    authorize @cart
    @cart.destroy!
    redirect_to pending_path
  end

  private

  # Sets the cart instance variable based on the provided id
  def set_cart
    @cart = Cart.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Carrinho não encontrado."
    redirect_to root_path
  end

  # Sets the new cart instance variable
  def set_new_cart
    @cart.storage = @storage
    @cart.requestor_id = current_user.id
    @cart.approver_id = current_user.id
  end

  # Renders a PDF format of the carts list
  def render_pdf
    return unless request.format.pdf?

    @one_chemical = params[:chemical].to_i > 0 ? Chemical.find(params[:chemical]) : false
    pdf = CartPdf.new(@carts, @one_chemical).call
    send_data pdf, filename: "Relatório de movimentação.pdf", type: "application/pdf"
  end

  # Processes the cart record
  def cart_record
    @cart.description = params[:cart][:description]
    @cart.date_move = Time.now
    manager = @cart.storage.farm.employees.find_by(user_id: current_user.id)
    @cart.approved = (manager.present? && manager.manager) || @cart.storage.farm.user == current_user ? true : false
    @cart.approver_id = current_user.id
  end

  # A collection of chemicals with their total exited quantities.
  def exit_chemicals
    @carts = @cart.storage.carts
    @chemicals_exit = Chemical.joins(:cart_chemicals)
                              .where(cart_chemicals: { cart_id: @carts.where(approved: true).ids })
                              .group('chemicals.id')
                              .having('SUM(cart_chemicals.quantity) > 0')
                              .select('chemicals.*, SUM(cart_chemicals.quantity) AS total_quantity')
                              .order(product_name: :asc)
  end
end
