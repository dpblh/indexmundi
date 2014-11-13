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

ActiveRecord::Schema.define(version: 20141112200212) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "rus_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "translate",  default: false
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "rus_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "value_from_table"
    t.string   "value_from_compare"
    t.boolean  "translate",          default: false
  end

  create_table "graph_positions", force: true do |t|
    t.integer  "value"
    t.integer  "property_position_id"
    t.integer  "year_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graph_positions", ["value"], name: "index_graph_positions_on_value", using: :btree

  create_table "logs", force: true do |t|
    t.string   "level"
    t.string   "text"
    t.text     "stack_trace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_names", force: true do |t|
    t.string   "name"
    t.string   "rus_name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "value_from_table"
    t.boolean  "translate",        default: false
  end

  create_table "property_positions", force: true do |t|
    t.text     "text"
    t.integer  "rating"
    t.integer  "country_id"
    t.integer  "property_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "translate",        default: false
    t.text     "rus_text"
  end

  add_index "property_positions", ["rating"], name: "index_property_positions_on_rating", using: :btree

  create_table "years", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "value",      limit: 24
  end

end
