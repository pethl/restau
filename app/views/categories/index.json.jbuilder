json.array!(@categories) do |category|
  json.extract! category, :id, :name, :reference
  json.url category_url(category, format: :json)
end
