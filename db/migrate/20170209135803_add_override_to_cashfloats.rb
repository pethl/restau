class AddOverrideToCashfloats < ActiveRecord::Migration
  def change
     add_column :cashfloats, :override, :boolean,           default: false
  end
end
