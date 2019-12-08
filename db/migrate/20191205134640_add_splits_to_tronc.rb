class AddSplitsToTronc < ActiveRecord::Migration
  def change
     add_column :troncs, :foh_split, :decimal, precision: 6, scale: 3
     add_column :troncs, :kitchen_split, :decimal, precision: 6, scale: 3
  end
end
