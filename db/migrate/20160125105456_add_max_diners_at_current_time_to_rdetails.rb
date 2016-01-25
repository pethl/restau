class AddMaxDinersAtCurrentTimeToRdetails < ActiveRecord::Migration
  def change
     add_column :rdetails, :max_diners_at_current_time, :integer
  end
end
