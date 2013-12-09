module ActivePricing
  # active price result
  def new_daily_price
    ActivePricingCalculator.new_daily_price(id, cost_price, current_stock, minimum_stock)
  end

  # minimum profit price
  def profit_price
    ActivePricingCalculator.profit_price(cost_price)
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
    ActivePricingCalculator.stock_difference(current_stock, minimum_stock)
  end

  def sell_difference
    ActivePricingCalculator.sell_difference(id)
  end

  # update to active price
  def update_price
    self.update(daily_price: new_daily_price)
  end
end
