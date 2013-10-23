class ApiController < ApplicationController
  # Skip default authentications
  skip_before_action :verify_authenticity_token
  # TODO add in custom authentications

  # POST /api/transaction
  # POST /api/stores/:store_id/transaction
  def settlement
    reader = FileReader.new(params[:settlement], FileReader::SETTLEMENT)
    store = Store.find(params[:store_id])

    respond_to do |format|
      if reader.process(store)
        format.json { render json: 'Transaction file uploaded.', status: :created }
      else
        format.json { render json: 'Invalid Transaction file uploaded.', status: :unprocessable_entity }
      end
    end
  end

  # GET /api/price_list
  # GET /api/stores/:store_id/price_list
  def price_list
    @store = Store.find(params[:store_id]) if params[:store_id]

    if @store
      @products = @store.products.includes(:category, :manufacturer)
    else
      @products = Product.all.includes(:category, :manufacturer)
    end
  end

  # GET /api/customers
  def customers
    @users = User.where(role: User::CUSTOMER)
  end
end
