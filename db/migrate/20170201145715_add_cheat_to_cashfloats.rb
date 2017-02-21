class AddCheatToCashfloats < ActiveRecord::Migration
  def change
    add_column :cashfloats, :cheat, :decimal, precision: 7, scale: 2
  end
end
