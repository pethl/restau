class ChangeColumnNameExpensesForDailybank < ActiveRecord::Migration
  def change
    rename_column :dailybanks, :expenses, :expenses_total
  end
end
