class AddBankingToDailybanks < ActiveRecord::Migration
  def change
    add_column :dailybanks, :banking, :decimal, precision: 8, scale: 2
  end
end
