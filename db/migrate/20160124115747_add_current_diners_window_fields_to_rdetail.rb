class AddCurrentDinersWindowFieldsToRdetail < ActiveRecord::Migration
  def change
     add_column :rdetails, :current_diners_window_start, :integer
     add_column :rdetails, :current_diners_window_end, :integer
  end
end
