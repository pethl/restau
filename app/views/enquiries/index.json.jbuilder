json.array!(@enquiries) do |enquiry|
  json.extract! enquiry, :id, :col_day, :col_time
  json.url enquiry_url(enquiry, format: :json)
end
