class AddSunMaxDinersToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :sun_max_diners, :integer
  end
end
