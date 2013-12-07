class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    if can? :view, Order
      @orders = Order.includes(:user).paginate(page: params[:page], per_page: 50)
    else
      @orders = current_user.orders.paginate(page: params[:page], per_page: 50)
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    unless user_signed_in?
      store_location_for(:user, new_order_path)
      redirect_to new_user_session_url, alert: "Please login before proceeds to Checkout."
      return
    end

    @cart = current_cart

    if @cart.empty?
      redirect_to root_url, notice: "Your cart is empty."
      return
    elsif @cart.out_of_stocks?
      redirect_to @cart, alert: "Items are out of stocks."
      return
    end

    @order = current_user.orders.new
    @order.add_user_info(current_user)
    @order.add_items_from_cart(@cart)
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.new(order_params)
    @order.add_user_info(current_user)
    @order.add_items_from_cart(current_cart)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Your order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :email, :phone, :address, :pay_type, :used_credit, :credit_card)
    end
end
