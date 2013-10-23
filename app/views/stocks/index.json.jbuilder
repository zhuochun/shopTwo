json.array!(@stocks) do |stock|
  json.extract! stock, :store_id, :product_id, :quantity, :minimum
  json.url stock_url(stock, format: :json)
end
