class CreateDailybanks < ActiveRecord::Migration
  def change
    create_table :dailybanks do |t|
      t.integer :user_id
      t.date :effective_date
      t.decimal :till_cash, precision: 8, scale: 2
      t.decimal :till_float, precision: 8, scale: 2
      t.decimal :card_payments, precision: 8, scale: 2
      t.decimal :expenses, precision: 8, scale: 2
      t.decimal :actual_cash_total, precision: 8, scale: 2
      t.decimal :till_takings, precision: 8, scale: 2
      t.decimal :wet_takings, precision: 8, scale: 2
      t.decimal :dry_takings, precision: 8, scale: 2
      t.decimal :merch_takings, precision: 8, scale: 2
      t.decimal :vouchers_sold, precision: 8, scale: 2
      t.decimal :vouchers_used, precision: 8, scale: 2
      t.decimal :deposit_sold, precision: 8, scale: 2
      t.decimal :deposit_used, precision: 8, scale: 2
      t.decimal :actual_till_takings, precision: 8, scale: 2
      t.decimal :calculated_variance, precision: 8, scale: 2
      t.decimal :user_variance, precision: 8, scale: 2
      t.decimal :varaince_comment, precision: 8, scale: 2
      t.string :status

      t.timestamps null: false
    end
  end
end
