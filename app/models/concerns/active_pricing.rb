module ActivePricing
  # dynamic pricing upper bound
  STOCK_UPPER_LIMIT = ENV['STOCK_UPPER_LIMIT'] ? ENV['STOCK_UPPER_LIMIT'].to_f : 1
  SELL_UPPER_LIMIT  = ENV['SELL_UPPER_LIMIT']  ? ENV['SELL_UPPER_LIMIT'].to_f  : 2
  # price weight of each part
  TOTAL_WEIGHT      = ENV['TOTAL_WEIGHT']      ? ENV['TOTAL_WEIGHT'].to_f      : 3.0
  MINIMUM_PROFIT    = ENV['MINIMUM_PROFIT']    ? ENV['MINIMUM_PROFIT'].to_f    : 0.3
  COST_WEIGHT       = ENV['COST_WEIGHT']       ? ENV['COST_WEIGHT'].to_f       : 1.0
  SELL_WEIGHT       = ENV['SELL_WEIGHT']       ? ENV['SELL_WEIGHT'].to_f       : 1.7
  STOCK_WEIGHT      = ENV['STOCK_WEIGHT']      ? ENV['STOCK_WEIGHT'].to_f      : 0.3

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
      [STOCK_UPPER_LIMIT, ((current_stock - minimum_stock) / minimum_stock.to_f)].min
    end
  end

  def sell_difference
    query = %(
      SELECT (AVG(week.quantity) - AVG(month.quantity)) / AVG(month.quantity) as diff
      FROM settle_items AS week, settle_items AS month
      WHERE week.barcode = #{id}
        AND month.barcode = #{id}
        AND week.created_at >= '#{Settlement.get_from_time(1.week).to_s(:db)}'
        AND month.created_at >= '#{Settlement.get_from_time(1.month).to_s(:db)}';)

    @sell_difference_fast ||= ActiveRecord::Base.connection().select_value(query)

    if @sell_difference_fast.nil?
      0
    else
      [SELL_UPPER_LIMIT, @sell_difference_fast.to_f].min
    end
  end

  # update to active price
  def update_price
    self.update(daily_price: new_daily_price)
  end
end
