class AddBigLargeTableCountFieldsToRdetail < ActiveRecord::Migration
  def change
    add_column :rdetails, :big_table_count, :integer
    add_column :rdetails, :large_table_count, :integer
    
  end
end
