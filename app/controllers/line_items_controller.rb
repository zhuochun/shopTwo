class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    @line_item = @cart.add_item(line_item_params)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @cart, notice: line_item_created_message }
        format.json { render action: 'show', status: :created, location: @line_item }
      else
        format.html { redirect_to @product, notice: 'Product was not added to your Cart.' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_item.cart }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      if can?(:view, LineItem)
        @line_item = LineItem.find(params[:id])
      else
        @line_item = current_cart.line_items.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id, :order_id, :quantity)
    end

    # Added to Cart message
    def line_item_created_message
      %{
        <p>Product was successfully added to your Cart.</p>
        <p><a class='btn btn-success' href='/'>Continue Shopping</a></p>
      }.html_safe
    end
end
