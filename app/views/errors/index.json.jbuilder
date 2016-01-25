json.array!(@errors) do |error|
  json.extract! error, :id, :ref, :msg, :desc
  json.url error_url(error, format: :json)
end
