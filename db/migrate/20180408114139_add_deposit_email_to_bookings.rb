class AddDepositEmailToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :deposit_email_sent, :string
  end
end
