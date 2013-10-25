class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :set_store

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = @store.stocks.includes(:product).paginate(page: params[:page], per_page: 50)
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/download.txt
  def download
    @stocks = @store.stocks.includes(:product)

    respond_to do |format|
      format.text # download.txt
      format.html { redirect_to action: 'index' }
    end
  end

  # GET /stocks/new
  def new
    @stock = @store.stocks.find_or_initialize_by(product_id: params[:product_id])
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = @store.stocks.find_or_initialize_by(product_id: params[:stock][:product_id])

    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render action: 'show', status: :created, location: @stock }
      else
        format.html { render action: 'new' }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /stocks/batch_new
  def batch_new
  end

  # POST /stocks/batch_create
  def batch_create
    reader = FileReader.new(params[:stocks], FileReader::STOCK)

    respond_to do |format|
      if reader.process(@store)
        format.html { redirect_to stocks_url, notice: "Stocks are uploaded." }
      else
        format.html { redirect_to action: "batch_new", notice: "Invalid file uploaded." }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    @update_params = params.require(:stock).permit(:quantity, :minimum)

    respond_to do |format|
      if @stock.update(@update_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.includes(:product).find(params[:id])
    end

    def set_store
      @store  = current_user.store || Store.find(params[:store_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:product_id, :quantity, :minimum)
    end
end
