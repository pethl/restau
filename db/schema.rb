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

ActiveRecord::Schema.define(version: 20160430142812) do

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
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "status"
    t.datetime "cancelled_at"
    t.integer  "restaurant_id"
    t.datetime "booking_date_time"
    t.string   "source"
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
    t.integer  "two_pound_bag"
    t.integer  "two_pound_single"
    t.string   "completed"
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
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "current_diners_window_start"
    t.integer  "current_diners_window_end"
    t.integer  "big_table_count"
    t.integer  "large_table_count"
    t.integer  "max_current_diners"
    t.integer  "max_diners_at_current_time"
    t.decimal  "safe_float",                  precision: 6, scale: 2
    t.decimal  "till_float_main",             precision: 6, scale: 2
    t.decimal  "till_float_bar",              precision: 6, scale: 2
    t.integer  "eve_full_diners"
    t.integer  "day_full_diners"
    t.integer  "afternoon_full_diners"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
