class AddSubscribedToCustomer < ActiveRecord::Migration
  def change
     add_column :customers, :subscribed, :boolean
  end
end
