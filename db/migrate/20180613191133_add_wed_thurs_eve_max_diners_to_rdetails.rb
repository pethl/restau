class AddWedThursEveMaxDinersToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :wed_thurs_eve_max_diners, :integer
  end
end
