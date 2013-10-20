json.array!(@product_in_shops) do |product_in_shop|
  json.extract! product_in_shop, :store_id, :product_id, :quantity
  json.url product_in_shop_url(product_in_shop, format: :json)
end
