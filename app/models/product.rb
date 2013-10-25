class Product < ActiveRecord::Base
  # alias
  alias_attribute :barcode, :id

  # relationship
  belongs_to :category, counter_cache: true
  belongs_to :manufacturer, counter_cache: true

  has_many :stocks
  has_many :stores, through: :stocks

  has_many :settle_items, foreign_key: 'barcode'
  has_many :settlements, through: :settle_items

  # validations
  validates :name, :barcode, :cost_price, :current_stock, :minimum_stock, presence: true
  validates :current_stock, :minimum_stock, :bundle_unit, numericality: { greater_than_or_equal_to: 0 }
  validates :daily_price, :cost_price, numericality: { greater_than_or_equal_to: 0 }

  # hooks
  before_validation -> { self.daily_price = cost_price * 1.3 unless daily_price }

  # scopes
  default_scope -> { includes(:manufacturer, :category).order('name ASC') }
  scope :new_in_store, -> { order('created_at DESC') }
  scope :popular, -> { order('current_stock DESC') }

  # on sell
  def on_sell?
    stocks.count > 0
  end

  # on reference
  def on_reference?
    stocks.count > 0 && settle_items.count > 0
  end

  # stocks available for stores to restock
  def available_stock
    current_stock - stocks.sum('quantity')
  end

  # dynamic pricing upper bound
  STOCK_UPPER_LIMIT = 1
  SELL_UPPER_LIMIT  = 2
  # price weight of each part
  TOTAL_WEIGHT      = 3.0
  MINIMUM_PROFIT    = 0.3
  COST_WEIGHT       = 1.0
  SELL_WEIGHT       = 1.7
  STOCK_WEIGHT      = 0.3

  # generate new price
  def profit_price
    cost_price * (1.0 + MINIMUM_PROFIT)
  end

  def new_daily_price
    (profit_price * COST_WEIGHT +
     profit_price * (1.0 + sell_difference) * SELL_WEIGHT +
     profit_price * (1.0 - stock_difference) * STOCK_WEIGHT) / TOTAL_WEIGHT
  end

  def stock_difference
    if minimum_stock == 0
      0
    else
      [STOCK_UPPER_LIMIT, ((current_stock - minimum_stock) / minimum_stock)].min
    end
  end

  def sell_difference
    week_sell  = settle_items.last_week.average('quantity')
    month_sell = settle_items.last_month.average('quantity')

    if week_sell.nil? || month_sell.nil? || month_sell == 0
      0
    else
      [SELL_UPPER_LIMIT, ((week_sell - month_sell) / month_sell)].min
    end
  end

  def weekly_sell
    @weekly_sell ||= settle_items.last_week.sum('quantity')
  end

  def monthly_sell
    @monthly_sell ||= settle_items.last_month.sum('quantity')
  end

  # update to active price
  def update_price
    self.daily_price = new_daily_price
    self.save
  end

  # dynamic pricing
  # OPTIMIZE better sql
  def self.active_pricing
    Product.transaction do
      self.find_each(batch_size: 500) do |product|
        product.update_price
      end
    end
  end
end
