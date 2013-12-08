class ApiController < ApplicationController
  respond_to :json

  # Skip default authentications
  skip_before_action :verify_authenticity_token
  # Setup store
  before_action :set_store, except: [:members]

  # TODO add in custom authentications

  # POST /api/:store_id/transaction
  def settlement
    reader = FileReader.new(params[:file], FileReader::SETTLEMENT)

    if reader.process(@store)
      render json: { succeed: true, message: 'Transaction file uploaded.' },
             status: :created
    else
      render json: { succeed: false, message: 'Invalid Transaction file uploaded.' },
             status: :unprocessable_entity
    end
  end

  # GET /api/:store_id/price_list
  def price_list
    @stocks = @store.stocks.includes(:product)

    if params[:active] == '1'
      render 'active_price_list'
    else
      render 'price_list'
    end
  end

  # GET /api/:store_id/price_list_paged/:page
  def price_list_paged
    @stocks = @store.stocks.includes(:product)
                    .paginate(page: params[:page], per_page: 500)

    if params[:active] == '1'
      render 'active_price_list_paged'
    else
      render 'price_list_paged'
    end
  end

  # GET /api/members
  def members
    @users = User.where(role: User::CUSTOMER)
  end

  # POST /api/:store_id/members
  def member_spendings
    reader = FileReader.new(params[:file], FileReader::SPENDING)

    if reader.process(@store)
      render json: { succeed: true, message: 'Spending file uploaded.' },
             status: :created
    else
      render json: { succeed: false, message: 'Invalid spending file uploaded.' },
             status: :unprocessable_entity
    end
  end

  private

  def set_store
    @store = Store.find(params[:store_id])
  end

end
