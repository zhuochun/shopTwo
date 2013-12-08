json.array!(@stocks) do |stock|
  json.extract! stock.product, :name, :barcode, :bundle_unit
  json.daily_price stock.new_daily_price.round(2)
  json.current_stock stock.quantity
  json.minimum_stock stock.minimum
  json.category stock.product.category.name
  json.manufacturer stock.product.manufacturer.name
end
