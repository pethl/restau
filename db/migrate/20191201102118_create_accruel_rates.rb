class CreateAccruelRates < ActiveRecord::Migration
  def change
    create_table :accruel_rates do |t|
      t.datetime :effective_date
      t.decimal :accruel_rate, :decimal, precision: 7, scale: 4

      t.timestamps null: false
    end
  end
end
