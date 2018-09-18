class AddMaxFriLunchDinersToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :max_fri_lunch_diners, :integer
  end
end
