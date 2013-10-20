json.array!(@settlements) do |settlement|
  json.extract! settlement, :store_id, :total_price, :uuid
  json.url settlement_url(settlement, format: :json)
end
