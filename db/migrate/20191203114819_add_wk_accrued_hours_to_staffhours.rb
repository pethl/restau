class AddWkAccruedHoursToStaffhours < ActiveRecord::Migration
  def change
     add_column :staffhours, :wk_accrued_hours, :decimal, precision: 15, scale: 10
  end
end
