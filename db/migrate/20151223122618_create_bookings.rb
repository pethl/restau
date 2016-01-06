class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :table_id
      t.integer :customer_id
      t.date :booking_date
      t.time :booking_time
      t.integer :number_of_diners
      t.boolean :accessible
      t.boolean :child_friendly

      t.timestamps null: false
    end
  end
end
