json.array!(@products) do |product|
  json.extract! product, :id, :name, :price, :weight, :category_id, :status, :desc, :sort, :feeds
  json.url product_url(product, format: :json)
end
