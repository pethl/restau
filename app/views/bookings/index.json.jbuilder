json.array!(@bookings) do |booking|
  json.extract! booking, :id, :table_id, :customer_id, :booking_date, :booking_time, :number_of_diners, :accessible, :child_friendly
  json.url booking_url(booking, format: :json)
end
