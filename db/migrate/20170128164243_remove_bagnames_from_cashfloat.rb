class RemoveBagnamesFromCashfloat < ActiveRecord::Migration
  def up
      remove_column :cashfloats, :two_pound_bag
      remove_column :cashfloats, :pound_bag
      remove_column :cashfloats, :fifty_bag
      remove_column :cashfloats, :twenty_bag
      remove_column :cashfloats, :ten_bag
      remove_column :cashfloats, :five_bag
      remove_column :cashfloats, :two_bag
      remove_column :cashfloats, :one_bag
    end

    def down
      remove_column :cashfloats, :two_pound_bag, :integer
      remove_column :cashfloats, :pound_bag, :integer
      remove_column :cashfloats, :fifty_bag, :integer
      remove_column :cashfloats, :twenty_bag, :integer
      remove_column :cashfloats, :ten_bag, :integer
      remove_column :cashfloats, :five_bag, :integer
      remove_column :cashfloats, :two_bag, :integer
      remove_column :cashfloats, :one_bag, :integer
    end
end
