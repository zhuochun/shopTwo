class ProductInShopsController < ApplicationController
  before_action :set_product_in_shop, only: [:show, :edit, :update, :destroy]

  # GET /product_in_shops
  # GET /product_in_shops.json
  def index
    @product_in_shops = ProductInShop.all
  end

  # GET /product_in_shops/1
  # GET /product_in_shops/1.json
  def show
  end

  # GET /product_in_shops/new
  def new
    @product_in_shop = ProductInShop.new
  end

  # GET /product_in_shops/1/edit
  def edit
  end

  # POST /product_in_shops
  # POST /product_in_shops.json
  def create
    @product_in_shop = ProductInShop.new(product_in_shop_params)

    respond_to do |format|
      if @product_in_shop.save
        format.html { redirect_to @product_in_shop, notice: 'Product in shop was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product_in_shop }
      else
        format.html { render action: 'new' }
        format.json { render json: @product_in_shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_in_shops/1
  # PATCH/PUT /product_in_shops/1.json
  def update
    respond_to do |format|
      if @product_in_shop.update(product_in_shop_params)
        format.html { redirect_to @product_in_shop, notice: 'Product in shop was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product_in_shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_in_shops/1
  # DELETE /product_in_shops/1.json
  def destroy
    @product_in_shop.destroy
    respond_to do |format|
      format.html { redirect_to product_in_shops_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_in_shop
      @product_in_shop = ProductInShop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_in_shop_params
      params.require(:product_in_shop).permit(:store_id, :product_id, :quantity)
    end
end
