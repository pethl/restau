class AddFieldsToTroncs < ActiveRecord::Migration
  def change
    add_column :troncs, :card_split, :decimal, precision: 6, scale: 3
    add_column :troncs, :mgr_split, :decimal, precision: 6, scale: 3
    add_column :troncs, :foh_method, :string
    add_column :troncs, :kit_method, :string
  end
end
