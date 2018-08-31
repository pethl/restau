class AddConfirmationEmailFieldsToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :confirmation_sent, :boolean
    add_column :bookings, :confirmation_received, :boolean
  end
end
