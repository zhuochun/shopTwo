json.array!(@manufacturers) do |manufacturer|
  json.extract! manufacturer, :name
  json.url manufacturer_url(manufacturer, format: :json)
end
