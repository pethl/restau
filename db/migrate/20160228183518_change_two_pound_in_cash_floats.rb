class ChangeTwoPoundInCashFloats < ActiveRecord::Migration
  def self.up
    change_column :cashfloats, :two_pound_bag, :integer
    change_column :cashfloats, :two_pound_single, :integer
  end
end
