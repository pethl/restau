# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exemption do
    exempt_day "2016-06-13"
    exempt_message "MyString"
  end
end
