class ChangeFloatFieldsToRdetails < ActiveRecord::Migration
  def self.up
    change_column :rdetails, :safe_float, :decimal, :precision => 6, :scale => 2
    change_column :rdetails, :till_float_main, :decimal, :precision => 6, :scale => 2
    change_column :rdetails, :till_float_bar, :decimal, :precision => 6, :scale => 2
  end
end
