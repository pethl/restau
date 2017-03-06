class AddTillFieldsToDailybank < ActiveRecord::Migration
  def change
    add_column :dailybanks, :terminal_1, :decimal, precision: 7, scale: 2
    add_column :dailybanks, :terminal_2, :decimal, precision: 7, scale: 2
    add_column :dailybanks, :tablet_1, :decimal, precision: 7, scale: 2
    add_column :dailybanks, :tablet_2, :decimal, precision: 7, scale: 2
  end
end
