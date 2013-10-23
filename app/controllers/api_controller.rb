class ApiController < ApplicationController
  # Skip default authentications
  skip_before_action :verify_authenticity_token
  # TODO add in custom authentications

  # POST /api/transactions?store_id=*
  def transactions
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
  def price_list
    @products = Product.all.includes(:category, :manufacturer)
  end

  # GET /api/customers
  def customers
    @users = User.where(role: User::CUSTOMER)
  end
end
