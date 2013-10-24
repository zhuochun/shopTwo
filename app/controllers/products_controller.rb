class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :update_price, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.paginate(page: params[:page], per_page: 50)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # GET /products/batch_new
  def batch_new
  end

  # POST /products/batch_create
  def batch_create
    reader = FileReader.new(params[:inventory], FileReader::INVENTORY)

    respond_to do |format|
      if reader.process
        format.html { redirect_to products_url, notice: "Inventories are uploaded." }
      else
        format.html { redirect_to action: "batch_new", notice: "Invalid file uploaded." }
      end
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1/update_price
  # PATCH/PUT /products/1/update_price.json
  def update_price
    respond_to do |format|
      if @product.update_price
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end

      format.js # update_price
    end
  end

  # POST /products/active_pricing
  # POST /products/active_pricing.json
  def active_pricing
    if ENV['delayed_job']
      Product.delay.active_pricing
    else
      Product.active_pricing
    end

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
      format.json { head :no_content }
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    respond_to do |format|
      if @product.on_reference?
        format.html { redirect_to products_url, alert: "Product #{@product.name} is on sell." }
        format.json { render json: { errors: 'Product is on sell.' }, status: :unprocessable_entity }
      else
        @product.destroy

        format.html { redirect_to products_url }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :category_id, :manufacturer_id,
                                      :barcode, :daily_price, :cost_price,
                                      :current_stock, :minimum_stock, :bundle_unit)
    end
end
