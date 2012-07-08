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

ActiveRecord::Schema.define(:version => 20120708164447) do

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.boolean  "published",    :default => false
    t.datetime "published_at"
    t.integer  "user_id"
    t.integer  "section_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "rights", :force => true do |t|
    t.string "name"
    t.string "controller"
    t.string "action"
    t.string "description"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "sections", :force => true do |t|
    t.string   "title"
    t.integer  "order"
    t.string   "controller", :default => "no"
    t.string   "action",     :default => "no"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "published",  :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "second_name"
    t.string   "email"
    t.datetime "remember_token_expires_at"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id",                   :default => 2
  end

end
