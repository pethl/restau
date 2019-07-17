class AddGratuityToDailybank < ActiveRecord::Migration
  def change
    add_column :dailybanks, :gratuity_1, :decimal, precision: 8, scale: 2
    add_column :dailybanks, :gratuity_2, :decimal, precision: 8, scale: 2
  end
end
