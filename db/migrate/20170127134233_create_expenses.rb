class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :dailybank_id
      t.string :what
      t.string :where
      t.decimal :price, precision: 8, scale: 2
      t.integer :ref

      t.timestamps null: false
    end
  end
end
