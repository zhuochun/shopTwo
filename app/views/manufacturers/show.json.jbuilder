json.array!(@products) do |product|
  json.extract! product, :name, :category_id, :manufacturer_id,
                         :barcode, :daily_price, :cost_price,
                         :current_stock, :minimum_stock, :bundle_unit
  json.url product_url(product, format: :json)
end
