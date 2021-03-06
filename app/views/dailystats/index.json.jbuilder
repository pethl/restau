json.array!(@dailystats) do |dailystat|
  json.extract! dailystat, :id, :action_date, :cancelled_bookings, :confirmed_bookings, :diners_fed, :avg_headcount_per_booking, :avg_days_prior_to_booking, :avg_days_prior_to_booking_under_seven, :avg_days_prior_to_booking_over_six, :dawn, :early, :lunch, :afternoon, :hometime, :evening
  json.url dailystat_url(dailystat, format: :json)
end
