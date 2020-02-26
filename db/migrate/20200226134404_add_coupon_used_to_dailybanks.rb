class AddCouponUsedToDailybanks < ActiveRecord::Migration
  def change
    add_column :dailybanks, :coupons_used, :decimal, precision: 7, scale: 2
  end
end
