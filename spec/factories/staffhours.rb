# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :staffhour do
    week_end_date "2019-12-01 10:58:56"
    staff nil
    hours "9.99"
    payment_terms "MyString"
    accruelrate nil
  end
end
