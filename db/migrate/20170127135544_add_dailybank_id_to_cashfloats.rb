class AddDailybankIdToCashfloats < ActiveRecord::Migration
  def change
    add_column :cashfloats, :dailybank_id, :integer
  end
end
