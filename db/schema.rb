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

ActiveRecord::Schema.define(version: 20160118134341) do

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
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "status"
    t.datetime "cancelled_at"
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
  end

  create_table "enquiries", force: :cascade do |t|
    t.date     "col_day"
    t.time     "col_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
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
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_token"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
