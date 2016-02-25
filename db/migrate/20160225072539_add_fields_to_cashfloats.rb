class AddFieldsToCashfloats < ActiveRecord::Migration
  def change
    add_column :cashfloats, :two_pound_bag, :float
    add_column :cashfloats, :two_pound_single, :float
    add_column :cashfloats, :completed, :string
  end
end
