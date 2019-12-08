class CreateTroncs < ActiveRecord::Migration
  def change
    create_table :troncs do |t|
      t.date :start_date
      t.date :end_date
      t.string :status
      t.decimal :total

      t.timestamps null: false
    end
  end
end
