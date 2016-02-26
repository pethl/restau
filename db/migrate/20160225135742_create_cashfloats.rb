class CreateCashfloats < ActiveRecord::Migration
  def change
    create_table :cashfloats do |t|
      t.string   "float_type"
      t.string   "period"
      t.string   "completed_by"
      t.string   "user_code"
      t.integer  "fifties"
      t.integer  "twenties"
      t.integer  "tens"
      t.integer  "fives"
      t.integer  "pound_bag"
      t.integer  "pound_single"
      t.integer  "fifty_bag"
      t.integer  "fifty_single"
      t.integer  "twenty_bag"
      t.integer  "twenty_single"
      t.integer  "ten_bag"
      t.integer  "ten_single"
      t.integer  "five_bag"
      t.integer  "five_single"
      t.integer  "two_bag"
      t.integer  "two_single"
      t.integer  "one_bag"
      t.integer  "one_single"
      t.float    "float_actual"
      t.float    "float_target"
      t.float    "float_gap"
      t.text     "float_comment"
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
      t.float    "two_pound_bag"
      t.float    "two_pound_single"
      t.string   "completed"

      t.timestamps null: false
    end
  end
end
