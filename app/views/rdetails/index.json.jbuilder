json.array!(@rdetails) do |rdetail|
  json.extract! rdetail, :id, :restaurant_id, :booking_duration, :min_booking, :max_booking, :last_booking_time
  json.url rdetail_url(rdetail, format: :json)
end
