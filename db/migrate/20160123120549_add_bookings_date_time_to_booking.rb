class AddBookingsDateTimeToBooking < ActiveRecord::Migration
  def change
     add_column :bookings, :booking_date_time, :datetime
  end
end
