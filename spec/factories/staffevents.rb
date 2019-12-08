# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :staffevent do
    staff_id 1
    event_date "2019-11-29 19:34:37"
    event_reason "MyString"
    event_notes "MyText"
  end
end
