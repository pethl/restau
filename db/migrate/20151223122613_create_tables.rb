class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :restaurant_id
      t.string :reference
      t.text :desc
      t.integer :min_seats
      t.integer :max_seats
      t.boolean :accessible
      t.boolean :child_friendly

      t.timestamps null: false
    end
  end
end
