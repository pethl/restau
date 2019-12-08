class AddRateToAccruelRate < ActiveRecord::Migration
  def change
    add_column :accruel_rates, :rate, :decimal, precision: 8, scale: 4
  end
end
