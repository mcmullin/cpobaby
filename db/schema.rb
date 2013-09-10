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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130910205618) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "secondary"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "addresses", ["addressable_type", "addressable_id"], :name => "index_addresses_on_addressable_type_and_addressable_id"

  create_table "admins", :force => true do |t|
    t.string   "email",              :default => "", :null => false
    t.string   "encrypted_password", :default => "", :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["unlock_token"], :name => "index_admins_on_unlock_token", :unique => true

  create_table "line_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.boolean  "free",       :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.decimal  "price"
    t.decimal  "subtotal"
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.string   "number"
    t.date     "date"
    t.integer  "rep_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "orders", ["number"], :name => "index_orders_on_number", :unique => true
  add_index "orders", ["rep_id", "date"], :name => "index_orders_on_rep_id_and_date"

  create_table "phones", :force => true do |t|
    t.string   "number",         :limit => 12
    t.string   "extension",      :limit => 6
    t.string   "country",        :limit => 6,  :default => "1", :null => false
    t.string   "description"
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "phones", ["phoneable_type", "phoneable_id"], :name => "index_phones_on_phoneable_type_and_phoneable_id"

  create_table "products", :force => true do |t|
    t.string   "item_number"
    t.string   "description"
    t.string   "category"
    t.decimal  "retail"
    t.decimal  "cpo"
    t.decimal  "points"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "discontinued", :default => false
    t.string   "state"
  end

  add_index "products", ["item_number"], :name => "index_products_on_item_number", :unique => true
  add_index "products", ["state"], :name => "index_products_on_state"

  create_table "reps", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "number"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "reps", ["confirmation_token"], :name => "index_reps_on_confirmation_token", :unique => true
  add_index "reps", ["email"], :name => "index_reps_on_email", :unique => true
  add_index "reps", ["number"], :name => "index_reps_on_number", :unique => true
  add_index "reps", ["reset_password_token"], :name => "index_reps_on_reset_password_token", :unique => true

end
