json.array!(@expenses) do |expense|
  json.extract! expense, :id, :dailybank_id, :what, :where, :price, :price, :ref
  json.url expense_url(expense, format: :json)
end
