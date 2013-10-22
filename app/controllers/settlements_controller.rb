class SettlementsController < ApplicationController
  before_action :set_settlement, only: [:show, :edit, :update, :destroy]

  # GET /settlements
  # GET /settlements.json
  def index
    @settlements = Settlement.all
  end

  # GET /settlements/1
  # GET /settlements/1.json
  def show
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
    store = Store.find(params[:store_id])

    respond_to do |format|
      if reader.process(store)
        format.html { redirect_to settlements_url, notice: "Transaction summary was successfully uploaded." }
        format.json { render action: 'index', status: :created, location: settlements_url }
      else
        format.html { redirect_to action: "new", notice: "Invalid Transaction file uploaded." }
        format.json { render json: "Invalid Transaction file uploaded.", status: :unprocessable_entity }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def settlement_params
      params.require(:settlement).permit(:store_id, :total_price, :uuid)
    end
end
