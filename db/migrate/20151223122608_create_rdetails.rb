class CreateRdetails < ActiveRecord::Migration
  def change
    create_table :rdetails do |t|
      t.integer :restaurant_id
      t.decimal :booking_duration
      t.integer :min_booking
      t.integer :max_booking
      t.time :last_booking_time

      t.timestamps null: false
    end
  end
end
