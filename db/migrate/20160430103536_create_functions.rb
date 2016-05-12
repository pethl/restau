class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string :status
      t.date :event_date
      t.integer :party_size
      t.string :customer_name
      t.string :phone
      t.string :email
      t.text :message
      t.string :event_type
      t.time :event_start_time
      t.time :event_end_time
      t.float :deposit_amount
      t.string :deposit_paid
      t.string :t_and_c_signed
      t.string :menu_choice

      t.timestamps null: false
    end
  end
end
