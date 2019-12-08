class AddAreaToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :area, :string
  end
end
