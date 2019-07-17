class AddGratuityTotalToDailybank < ActiveRecord::Migration
  def change
    add_column :dailybanks, :gratuity_total, :decimal, precision: 8, scale: 2
  end
end
