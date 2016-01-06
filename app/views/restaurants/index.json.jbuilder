json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :account_id, :name, :location, :website, :primary_contact, :email, :phone
  json.url restaurant_url(restaurant, format: :json)
end
