# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180914093901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "company_name"
    t.string   "primary_contact"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "table_id"
    t.integer  "customer_id"
    t.date     "booking_date"
    t.time     "booking_time"
    t.integer  "number_of_diners"
    t.boolean  "accessible"
    t.boolean  "child_friendly"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "status"
    t.datetime "cancelled_at"
    t.integer  "restaurant_id"
    t.datetime "booking_date_time"
    t.string   "source"
    t.string   "notes"
    t.decimal  "deposit_amount",           precision: 7, scale: 2
    t.string   "deposit_code"
    t.string   "deposit_pay_method"
    t.string   "deposit_email_sent"
    t.boolean  "confirmation_sent"
    t.boolean  "confirmation_received"
    t.string   "stripe_id"
    t.integer  "stripe_amount"
    t.datetime "stripe_deposit_paid_date"
  end

  create_table "cashfloats", force: :cascade do |t|
    t.string   "float_type"
    t.string   "period"
    t.string   "completed_by"
    t.string   "user_code"
    t.integer  "fifties"
    t.integer  "twenties"
    t.integer  "tens"
    t.integer  "fives"
    t.integer  "pound_single"
    t.decimal  "fifty_single",     precision: 5, scale: 2
    t.decimal  "twenty_single",    precision: 5, scale: 2
    t.decimal  "ten_single",       precision: 5, scale: 2
    t.decimal  "five_single",      precision: 5, scale: 2
    t.decimal  "two_single",       precision: 5, scale: 2
    t.decimal  "one_single",       precision: 5, scale: 2
    t.float    "float_actual"
    t.float    "float_target"
    t.float    "float_gap"
    t.text     "float_comment"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "two_pound_single"
    t.string   "completed"
    t.integer  "dailybank_id"
    t.decimal  "cheat",            precision: 7, scale: 2
    t.boolean  "override",                                 default: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.text     "desc"
    t.boolean  "accessible"
    t.boolean  "child_friendly"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "subscribed"
  end

  create_table "dailybanks", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "effective_date"
    t.decimal  "till_cash",             precision: 8, scale: 2
    t.decimal  "till_float",            precision: 8, scale: 2
    t.decimal  "card_payments",         precision: 8, scale: 2
    t.decimal  "expenses_total",        precision: 8, scale: 2
    t.decimal  "actual_cash_total",     precision: 8, scale: 2
    t.decimal  "till_takings",          precision: 8, scale: 2
    t.decimal  "wet_takings",           precision: 8, scale: 2
    t.decimal  "dry_takings",           precision: 8, scale: 2
    t.decimal  "merch_takings",         precision: 8, scale: 2
    t.decimal  "vouchers_sold",         precision: 8, scale: 2
    t.decimal  "vouchers_used",         precision: 8, scale: 2
    t.decimal  "deposit_sold",          precision: 8, scale: 2
    t.decimal  "deposit_used",          precision: 8, scale: 2
    t.decimal  "actual_till_takings",   precision: 8, scale: 2
    t.decimal  "calculated_variance",   precision: 8, scale: 2
    t.decimal  "user_variance",         precision: 8, scale: 2
    t.decimal  "varaince_comment",      precision: 8, scale: 2
    t.string   "status"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.decimal  "variance_gap",          precision: 8, scale: 2
    t.string   "variance_comment"
    t.decimal  "banking",               precision: 8, scale: 2
    t.decimal  "card_1",                precision: 7, scale: 2
    t.decimal  "card_2",                precision: 7, scale: 2
    t.decimal  "reported_till_takings", precision: 7, scale: 2
    t.decimal  "v_d_adjustments",       precision: 7, scale: 2
    t.boolean  "till_takings_check"
    t.decimal  "total_expected_cash",   precision: 7, scale: 2
    t.decimal  "total_eft_taken",       precision: 7, scale: 2
    t.decimal  "terminal_1",            precision: 7, scale: 2
    t.decimal  "terminal_2",            precision: 7, scale: 2
    t.decimal  "tablet_1",              precision: 7, scale: 2
    t.decimal  "tablet_2",              precision: 7, scale: 2
  end

  create_table "dailystats", force: :cascade do |t|
    t.date     "action_date"
    t.integer  "cancelled_bookings"
    t.integer  "confirmed_bookings"
    t.integer  "diners_fed"
    t.float    "avg_headcount_per_booking"
    t.float    "avg_days_prior_to_booking"
    t.float    "avg_days_prior_to_booking_under_seven"
    t.float    "avg_days_prior_to_booking_over_six"
    t.integer  "dawn"
    t.integer  "early"
    t.integer  "lunch"
    t.integer  "afternoon"
    t.integer  "hometime"
    t.integer  "evening"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "early_lunch"
    t.integer  "late_lunch"
    t.integer  "early_eve"
    t.integer  "late_eve"
  end

  create_table "enquiries", force: :cascade do |t|
    t.date     "col_day"
    t.time     "col_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "errors", force: :cascade do |t|
    t.string   "ref"
    t.string   "msg"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exemptions", force: :cascade do |t|
    t.date     "exempt_day"
    t.string   "exempt_message"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.integer  "dailybank_id"
    t.string   "what"
    t.string   "where"
    t.decimal  "price",        precision: 8, scale: 2
    t.integer  "ref"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "functions", force: :cascade do |t|
    t.string   "status"
    t.date     "event_date"
    t.integer  "party_size"
    t.string   "customer_name"
    t.string   "phone"
    t.string   "email"
    t.text     "message"
    t.string   "event_type"
    t.time     "event_start_time"
    t.time     "event_end_time"
    t.float    "deposit_amount"
    t.string   "deposit_paid"
    t.string   "t_and_c_signed"
    t.string   "menu_choice"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "est_party_size"
    t.string   "est_time"
    t.string   "when_is_event"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.string   "weight"
    t.integer  "category_id"
    t.string   "status"
    t.text     "desc"
    t.integer  "sort"
    t.integer  "feeds"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "rdetails", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.decimal  "booking_duration"
    t.integer  "min_booking"
    t.integer  "max_booking"
    t.time     "last_booking_time"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "current_diners_window_start"
    t.integer  "current_diners_window_end"
    t.integer  "big_table_count"
    t.integer  "large_table_count"
    t.integer  "max_current_diners"
    t.integer  "max_diners_at_current_time"
    t.decimal  "safe_float",                    precision: 6, scale: 2
    t.decimal  "till_float_main",               precision: 6, scale: 2
    t.decimal  "till_float_bar",                precision: 6, scale: 2
    t.integer  "eve_full_diners"
    t.integer  "day_full_diners"
    t.integer  "afternoon_full_diners"
    t.integer  "wed_thurs_eve_max_diners"
    t.integer  "confirmation_email_diners_max"
    t.integer  "deposit_max"
    t.integer  "max_fri_lunch_diners"
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "location"
    t.string   "website"
    t.string   "primary_contact"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "tables", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.string   "reference"
    t.text     "desc"
    t.integer  "min_seats"
    t.integer  "max_seats"
    t.boolean  "accessible"
    t.boolean  "child_friendly"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "position"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.boolean  "super_user",      default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
