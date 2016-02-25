class AddFloatFieldsToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :safe_float, :decimal, precision: 5, scale: 2
    add_column :rdetails, :till_float_main, :decimal, precision: 5, scale: 2
    add_column :rdetails, :till_float_bar, :decimal, precision: 5, scale: 2
  end
end
