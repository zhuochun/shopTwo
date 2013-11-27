class HomeController < ApplicationController
  # GET /index
  def index
    if current_user && current_user.management?
      render :dashboard
    else
      @new_products = Product.new_in_store.take(4)
      @popular_products = Product.popular(40)
    end
  end

  # GET /deals
  def today_deals
  end

  # GET /dashboard
  def dashboard
  end

  # GET /search
  def search
    @engine = SearchEngine::Searchable.new(Product, params[:q], all: true)
    @query  = @engine.query
    @products = @engine.lookup.paginate(page: params[:page], per_page: 50).reorder(:daily_price)
  end
end
