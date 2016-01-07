class AddStatusToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :status, :string
    add_column :bookings, :cancelled_at, :datetime
  end
end
