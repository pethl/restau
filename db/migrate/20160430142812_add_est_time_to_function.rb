class AddEstTimeToFunction < ActiveRecord::Migration
  def change
    add_column :functions, :est_time, :string
  end
end
