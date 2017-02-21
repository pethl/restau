class AddTillfieldsToDailybanks < ActiveRecord::Migration
  def change
    add_column :dailybanks, :total_expected_cash, :decimal, precision: 7, scale: 2
    add_column :dailybanks, :total_eft_taken, :decimal, precision: 7, scale: 2
  end
end
