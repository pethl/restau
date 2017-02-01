class AddCardFieldsToDailybanks < ActiveRecord::Migration
  def change
     add_column :dailybanks, :card_1, :decimal, precision: 7, scale: 2
     add_column :dailybanks, :card_2, :decimal, precision: 7, scale: 2
  end
end
