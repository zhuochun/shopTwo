json.array!(@stores) do |store|
  json.extract! store, :name, :size, :address, :geo_latitude, :geo_longitude, :contact, :operation_hours
  json.url store_url(store, format: :json)
end
