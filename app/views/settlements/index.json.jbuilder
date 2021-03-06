json.array!(@settlements) do |settlement|
  json.extract! settlement, :store_id, :total_price, :total_count
  json.url settlement_url(settlement, format: :json)
end