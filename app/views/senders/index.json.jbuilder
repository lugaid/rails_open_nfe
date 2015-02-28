json.array!(@senders) do |sender|
  json.extract! sender, :id, :name, :cnpj, :certificate, :nfe_sender
  json.url sender_url(sender, format: :json)
end
