class AddVarianceGapToDailybank < ActiveRecord::Migration
  def change
     add_column :dailybanks, :variance_gap, :decimal, precision: 8, scale: 2
  end
end
