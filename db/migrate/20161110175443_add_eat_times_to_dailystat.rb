class AddEatTimesToDailystat < ActiveRecord::Migration
  def change
    add_column :dailystats, :early_lunch, :integer
    add_column :dailystats, :late_lunch, :integer
    add_column :dailystats, :early_eve, :integer
    add_column :dailystats, :late_eve, :integer
  end
end
