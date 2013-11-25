module ActivePricing
  # dynamic pricing upper bound
  STOCK_UPPER_LIMIT = 1
  SELL_UPPER_LIMIT  = 2
  # price weight of each part
  TOTAL_WEIGHT      = 3.0
  MINIMUM_PROFIT    = 0.3
  COST_WEIGHT       = 1.0
  SELL_WEIGHT       = 1.7
  STOCK_WEIGHT      = 0.3

  # active price result
  def new_daily_price
    (profit_price * COST_WEIGHT +
     profit_price * (1.0 + sell_difference) * SELL_WEIGHT +
     profit_price * (1.0 - stock_difference) * STOCK_WEIGHT) / TOTAL_WEIGHT
  end

  # minimum profit price
  def profit_price
    cost_price * (1.0 + MINIMUM_PROFIT)
  end

  # sells in this week
  def weekly_sell
    @weekly_sell ||= settle_items.last_week.sum('quantity')
  end

  # sells in this month
  def monthly_sell
    @monthly_sell ||= settle_items.last_month.sum('quantity')
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

  # update to active price
  def update_price
    self.daily_price = new_daily_price
    self.save
  end
end
