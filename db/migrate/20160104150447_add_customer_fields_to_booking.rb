class AddCustomerFieldsToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :name, :string
    add_column :bookings, :email, :string
    add_column :bookings, :phone, :string
  end
end
