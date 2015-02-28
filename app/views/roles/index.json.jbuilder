json.array!(@roles) do |role|
  json.extract! role, :id, :name
  json.url sender_url(role, format: :json)
end
