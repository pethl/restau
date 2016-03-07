class AddFieldsToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :eve_full_diners, :integer
    add_column :rdetails, :day_full_diners, :integer
    add_column :rdetails, :afternoon_full_diners, :integer
  end
end
