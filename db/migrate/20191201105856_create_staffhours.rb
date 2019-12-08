class CreateStaffhours < ActiveRecord::Migration
  def change
    create_table :staffhours do |t|
      t.datetime :week_end_date
      t.references :staff, index: true, foreign_key: true
      t.decimal :hours, :decimal, precision: 7, scale: 2
      t.string :payment_terms
      t.references :accruel_rate, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
