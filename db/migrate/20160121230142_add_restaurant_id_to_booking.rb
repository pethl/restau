class AddRestaurantIdToBooking < ActiveRecord::Migration
  def change
     add_column :bookings, :restaurant_id, :integer
  end
end
