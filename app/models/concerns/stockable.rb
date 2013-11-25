module Stockable
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
end
