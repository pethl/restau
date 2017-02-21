class ChangeDataTypeForCashfloatFields < ActiveRecord::Migration
  
  change_table :cashfloats do |t|
    t.change :fifty_single, :decimal, precision: 5, scale: 2
    t.change :twenty_single, :decimal, precision: 5, scale: 2
    t.change :ten_single, :decimal, precision: 5, scale: 2
    t.change :five_single, :decimal, precision: 5, scale: 2
    t.change :two_single, :decimal, precision: 5, scale: 2
    t.change :one_single, :decimal, precision: 5, scale: 2 
  end
end
