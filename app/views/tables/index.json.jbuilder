json.array!(@tables) do |table|
  json.extract! table, :id, :restaurant_id, :reference, :desc, :min_seats, :max_seats, :accessible, :child_friendly
  json.url table_url(table, format: :json)
end
