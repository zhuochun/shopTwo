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

ActiveRecord::Schema.define(version: 20131023035321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "products_count"
  end

  create_table "manufacturers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "products_count"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.decimal  "daily_price",     precision: 9, scale: 2
    t.decimal  "cost_price",      precision: 9, scale: 2
    t.integer  "current_stock"
    t.integer  "minimum_stock"
    t.integer  "bundle_unit"
    t.integer  "category_id"
    t.integer  "manufacturer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["manufacturer_id"], name: "index_products_on_manufacturer_id", using: :btree

  create_table "settle_items", force: true do |t|
    t.integer  "settlement_id"
    t.integer  "barcode"
    t.integer  "quantity",                              default: 0
    t.decimal  "price",         precision: 9, scale: 2, default: 0.0
    t.decimal  "total_price",   precision: 9, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settle_items", ["barcode"], name: "index_settle_items_on_barcode", using: :btree
  add_index "settle_items", ["settlement_id"], name: "index_settle_items_on_settlement_id", using: :btree

  create_table "settlements", force: true do |t|
    t.integer  "store_id"
    t.integer  "total_count",                         default: 0
    t.decimal  "total_price", precision: 9, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settlements", ["store_id"], name: "index_settlements_on_store_id", using: :btree

  create_table "stocks", force: true do |t|
    t.integer  "store_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "minimum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["product_id"], name: "index_stocks_on_product_id", using: :btree
  add_index "stocks", ["store_id"], name: "index_stocks_on_store_id", using: :btree

  create_table "stores", force: true do |t|
    t.string   "name"
    t.integer  "size"
    t.text     "address"
    t.float    "geo_latitude"
    t.float    "geo_longitude"
    t.integer  "contact"
    t.text     "operation_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores", ["contact"], name: "index_stores_on_contact", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",                                        default: "",         null: false
    t.string   "phone"
    t.date     "birthday"
    t.decimal  "credits",                precision: 15, scale: 2, default: 0.1,        null: false
    t.string   "role",                                            default: "customer", null: false
    t.string   "email",                                           default: "",         null: false
    t.string   "encrypted_password",                              default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                                 default: 1,          null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["store_id"], name: "index_users_on_store_id", using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
