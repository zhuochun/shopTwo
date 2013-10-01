json.array!(@users) do |user|
  json.extract! user, :username, :phone, :birthday, :credits
end
