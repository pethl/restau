class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :desc
      t.boolean :accessible
      t.boolean :child_friendly

      t.timestamps null: false
    end
  end
end
