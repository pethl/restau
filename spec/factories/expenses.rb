# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expense do
    dailybank_id 1
    what "MyString"
    where "MyString"
    price ""
    price ""
    ref 1
  end
end
