# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dailybank do
    user_id 1
    effective_date "2016-07-21"
    till_cash "9.99"
    till_float "9.99"
    card_payments "9.99"
    expenses "9.99"
    actual_cash_total "9.99"
    till_takings "9.99"
    wet_takings "9.99"
    dry_takings "9.99"
    merch_takings "9.99"
    vouchers_sold "9.99"
    vouchers_used "9.99"
    deposit_sold "9.99"
    deposit_used "9.99"
    actual_till_takings "9.99"
    calculated_variance "9.99"
    user_variance "9.99"
    varaince_comment "9.99"
    status "MyString"
  end
end
