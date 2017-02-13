class AddTakingsCheckToDailybanks < ActiveRecord::Migration
  def change
    add_column :dailybanks, :till_takings_check, :boolean
  end
end
