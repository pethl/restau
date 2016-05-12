json.array!(@functions) do |function|
  json.extract! function, :id, :status, :event_date, :party_size, :customer_name, :phone, :email, :message, :event_type, :event_start_time, :event_end_time, :deposit_amount, :deposit_paid, :t_and_c_signed, :menu_choice
  json.url function_url(function, format: :json)
end
