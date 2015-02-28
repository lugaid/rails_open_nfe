json.array!(@users) do |user|
  json.extract! user, :id, :name
  json.url sender_url(user, format: :json)
end
