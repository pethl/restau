class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :bookings, :table_id
    add_index :bookings, :email
    add_index :bookings, :booking_date_time
    add_index :cashfloats, :dailybank_id
    add_index :expenses, :dailybank_id
    add_index :products, :category_id
    add_index :rdetails, :restaurant_id
    add_index :restaurants, :account_id
    add_index :staffevents, :staff_id
    add_index :tables, :restaurant_id
    add_index :dailybanks, :effective_date
    add_index :expenses, :ref
  end
end