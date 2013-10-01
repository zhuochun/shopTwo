class ApiController < ApplicationController
  # POST /api/transactions
  def transactions
    reader = FileReader.new(params[:inventory], FileReader::TRANSACTION)

    if reader.process
      render json: { result: 1 }
    else
      render json: { result: 0 }
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
