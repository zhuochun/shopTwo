class HomeController < ApplicationController
  # GET /index
  def index
  end

  # GET /deals
  def today_deals
  end

  # GET /dashboard
  def dashboard
  end

  # GET /search
  def search
    @query = params[:q].strip
    @products = query_products(@query).paginate(page: params[:page], per_page: 50).order('name ASC')
  end

  protected

  # Get products according to query
  def query_products(query)
    case query
    when /^\d{8}$/
      Product.where(barcode: query)
    when /^\$\d+$/
      Product.where(daily_price: query.slice(1, query.size))
    else
      Product.where("name LIKE ?", "%#{query}%")
    end
  end
end
