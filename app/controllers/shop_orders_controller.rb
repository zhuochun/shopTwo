class ShopOrdersController < ApplicationController
  before_action :set_shop_order, only: [:show, :edit, :update, :destroy]

  # GET /shop_orders
  # GET /shop_orders.json
  def index
    @shop_orders = ShopOrder.all
  end

  # GET /shop_orders/1
  # GET /shop_orders/1.json
  def show
  end

  # GET /shop_orders/new
  def new
    @shop_order = ShopOrder.new
  end

  # GET /shop_orders/1/edit
  def edit
  end

  # POST /shop_orders
  # POST /shop_orders.json
  def create
    @shop_order = ShopOrder.new(shop_order_params)

    respond_to do |format|
      if @shop_order.save
        format.html { redirect_to @shop_order, notice: 'Shop order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @shop_order }
      else
        format.html { render action: 'new' }
        format.json { render json: @shop_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shop_orders/1
  # PATCH/PUT /shop_orders/1.json
  def update
    respond_to do |format|
      if @shop_order.update(shop_order_params)
        format.html { redirect_to @shop_order, notice: 'Shop order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shop_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shop_orders/1
  # DELETE /shop_orders/1.json
  def destroy
    @shop_order.destroy
    respond_to do |format|
      format.html { redirect_to shop_orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop_order
      @shop_order = ShopOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_order_params
      params.require(:shop_order).permit(:user_id, :store_id, :quantity, :subtotal, :credits)
    end
end
