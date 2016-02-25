json.array!(@cashfloats) do |cashfloat|
  json.extract! cashfloat, :id
  json.url cashfloat_url(cashfloat, format: :json)
end
