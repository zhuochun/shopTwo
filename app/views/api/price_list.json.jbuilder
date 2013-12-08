json.array!(@stocks) do |stock|
  json.extract! stock.product, :name, :barcode, :daily_price, :bundle_unit
  json.current_stock stock.quantity
  json.minimum_stock stock.minimum
  json.category stock.product.category.name
  json.manufacturer stock.product.manufacturer.name
end
