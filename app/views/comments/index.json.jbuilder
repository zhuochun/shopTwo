json.array!(@comments) do |comment|
  json.extract! comment, :user_id, :product_id, :rating, :content
  json.url comment_url(comment, format: :json)
end
