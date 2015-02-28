json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :sender_id, :number, :series, :signed_xml
  json.url invoice_url(invoice, format: :json)
end
