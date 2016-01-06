class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.integer :account_id
      t.string :name
      t.string :location
      t.string :website
      t.string :primary_contact
      t.string :email
      t.string :phone

      t.timestamps null: false
    end
  end
end
