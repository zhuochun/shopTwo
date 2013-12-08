json.result do
  json.total_entries @stocks.total_entries
  json.total_pages @stocks.total_pages
  json.current_page @stocks.current_page
  json.offset @stocks.offset
  json.length @stocks.length
  json.stocks @stocks do |stock|
    json.extract! stock.product, :name, :barcode, :daily_price, :bundle_unit
    json.current_stock stock.quantity
    json.minimum_stock stock.minimum
    json.category stock.product.category.name
    json.manufacturer stock.product.manufacturer.name
  end
end
