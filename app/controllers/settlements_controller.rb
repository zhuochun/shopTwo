class SettlementsController < ApplicationController
  before_action :set_settlement, only: [:edit, :update, :destroy]
  before_action :set_store, only: [:index, :show, :create]

  # GET /settlements
  # GET /settlements.json
  def index
    if @store
      @settlements = @store.settlements.paginate(page: params[:page], per_page: 50)
    else
      @settlements = Settlement.paginate(page: params[:page], per_page: 50)
    end
  end

  # GET /settlements/1
  # GET /settlements/1.json
  def show
    if @store
      @settlement = @store.settlements.find(params[:id])
    else
      @settlement = Settlement.find(params[:id])
    end

    @items = @settlement.settle_items.includes(:product)
                        .paginate(page: params[:page], per_page: 50)
  end

  # Get /settlements/1/search
  # Get /settlements/1/search.json
  def search
    @settlement = Settlement.find(params[:id])
    @product = @settlement.settle_items.where(barcode: params[:q]).take
  end

  # GET /settlements/new
  def new
    @settlement = Settlement.new
  end

  # GET /settlements/1/edit
  def edit
  end

  # POST /settlements
  # POST /settlements.json
  def create
    reader = FileReader.new(params[:settlement], FileReader::SETTLEMENT)

    respond_to do |format|
      if reader.process(@store)
        format.html { redirect_to settlements_url, notice: 'Transaction summary was successfully uploaded.' }
        format.json { render action: 'index', status: :created, location: settlements_url }
      else
        format.html { redirect_to action: 'new', alert: 'Invalid Transaction file uploaded.' }
        format.json { render json: 'Invalid Transaction file uploaded.', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settlements/1
  # PATCH/PUT /settlements/1.json
  def update
    respond_to do |format|
      if @settlement.update(settlement_params)
        format.html { redirect_to @settlement, notice: 'Settlement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @settlement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settlements/1
  # DELETE /settlements/1.json
  def destroy
    @settlement.destroy
    respond_to do |format|
      format.html { redirect_to settlements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_settlement
      @settlement = Settlement.find(params[:id])
    end

    def set_store
      if current_user.store
        @store = current_user.store
      elsif params[:store_id]
        @store = Store.find(params[:store_id])
      else
        @store = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def settlement_params
      params.require(:settlement).permit(:store_id, :total_price, :uuid)
    end
end
