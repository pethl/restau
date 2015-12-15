class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.string :weight
      t.integer :category_id
      t.string :status
      t.text :desc
      t.integer :sort
      t.integer :feeds

      t.timestamps null: false
    end
  end
end
