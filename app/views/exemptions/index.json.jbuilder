json.array!(@exemptions) do |exemption|
  json.extract! exemption, :id, :exempt_day, :exempt_message
  json.url exemption_url(exemption, format: :json)
end
