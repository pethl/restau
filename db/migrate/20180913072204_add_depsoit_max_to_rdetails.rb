class AddDepsoitMaxToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :deposit_max, :integer
  end
end
