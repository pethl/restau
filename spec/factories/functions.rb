# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :function do
    status "MyString"
    event_date "2016-04-30"
    party_size 1
    customer_name "MyString"
    phone "MyString"
    email "MyString"
    message "MyText"
    event_type "MyString"
    event_start_time "2016-04-30 11:35:36"
    event_end_time "2016-04-30 11:35:36"
    deposit_amount 1.5
    deposit_paid "MyString"
    t_and_c_signed "MyString"
    menu_choice "MyString"
  end
end
