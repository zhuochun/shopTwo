json.array!(@shop_orders) do |shop_order|
  json.extract! shop_order, :id, :user_id, :store_id, :quantity, :subtotal, :credits
  json.url shop_order_url(shop_order, format: :json)
end
