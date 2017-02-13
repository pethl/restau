class AddFieldsToDailybanks < ActiveRecord::Migration
  def change
    add_column :dailybanks, :reported_till_takings, :decimal, precision: 7, scale: 2
    add_column :dailybanks, :v_d_adjustments, :decimal, precision: 7, scale: 2
  end
end
