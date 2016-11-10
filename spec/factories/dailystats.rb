# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dailystat do
    action_date "2016-11-10"
    cancelled_bookings 1
    confirmed_bookings 1
    diners_fed 1
    avg_headcount_per_booking 1.5
    avg_days_prior_to_booking 1.5
    avg_days_prior_to_booking_under_seven 1.5
    avg_days_prior_to_booking_over_six 1.5
    dawn 1
    early 1
    lunch 1
    afternoon 1
    hometime 1
    evening 1
  end
end
