class AddMaxCurrentDinersToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :max_current_diners, :integer
  end
end
