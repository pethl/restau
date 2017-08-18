class AddDepositToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :notes, :string
    add_column :bookings, :deposit_amount, :decimal, precision: 7, scale: 2
    add_column :bookings, :deposit_code, :string
    add_column :bookings, :deposit_pay_method, :string
  end
end
