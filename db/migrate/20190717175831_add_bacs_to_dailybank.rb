class AddBacsToDailybank < ActiveRecord::Migration
  def change
     add_column :dailybanks, :bacs, :decimal, precision: 8, scale: 2
  end
end
