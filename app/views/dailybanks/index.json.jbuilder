json.array!(@dailybanks) do |dailybank|
  json.extract! dailybank, :id, :user_id, :effective_date, :till_cash, :till_float, :card_payments, :expenses, :actual_cash_total, :till_takings, :wet_takings, :dry_takings, :merch_takings, :vouchers_sold, :vouchers_used, :deposit_sold, :deposit_used, :actual_till_takings, :calculated_variance, :user_variance, :varaince_comment, :status
  json.url dailybank_url(dailybank, format: :json)
end
