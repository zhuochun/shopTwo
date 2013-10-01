json.array!(@products) do |product|
  json.extract! product, :name, :barcode,
                         :daily_price, :current_stock,
                         :minimum_stock, :bundle_unit
  json.category product.category.name
  json.manufacturer product.manufacturer.name
end
