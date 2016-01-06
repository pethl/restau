json.array!(@accounts) do |account|
  json.extract! account, :id, :company_name, :primary_contact, :email, :phone
  json.url account_url(account, format: :json)
end
