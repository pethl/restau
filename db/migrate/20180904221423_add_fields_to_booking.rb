class AddFieldsToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :stripe_id, :string
    add_column :bookings, :stripe_amount, :integer
    add_column :bookings, :stripe_deposit_paid_date, :datetime
  end
end
