json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :phone, :email, :desc, :accessible, :child_friendly
  json.url customer_url(customer, format: :json)
end
