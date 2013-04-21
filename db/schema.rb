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

ActiveRecord::Schema.define(:version => 20130122202039) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "synopsis"
    t.text     "body"
    t.boolean  "published",                 :default => false
    t.datetime "published_at"
    t.integer  "category_id",               :default => 1
    t.integer  "user_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "header_image_file_name"
    t.string   "header_image_content_type"
    t.integer  "header_image_file_size"
    t.datetime "header_image_updated_at"
    t.string   "permalink"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "documents", :force => true do |t|
    t.integer  "order_id"
    t.string   "print_format"
    t.text     "user_comment"
    t.string   "paper_type"
    t.integer  "quantity"
    t.string   "margins"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "docfile_file_name"
    t.string   "docfile_content_type"
    t.integer  "docfile_file_size"
    t.datetime "docfile_updated_at"
  end

  create_table "letters", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "phone"
    t.string   "email"
    t.string   "question"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "delivery_street"
    t.string   "delivery_address"
    t.text     "delivery_comment"
    t.string   "status",           :default => "Определяется стоимость"
    t.float    "cost"
    t.text     "manager_comment"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.boolean  "published",     :default => false
    t.datetime "published_at"
    t.integer  "user_id"
    t.integer  "section_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "service_id"
    t.integer  "subservice_id"
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
    t.string   "permalink"
  end

  create_table "services", :force => true do |t|
    t.string   "title"
    t.string   "synopsis"
    t.string   "permalink"
    t.string   "service_header_icon_file_name"
    t.string   "service_header_icon_content_type"
    t.integer  "service_header_icon_file_size"
    t.datetime "service_header_icon_updated_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subservices", :force => true do |t|
    t.string   "title"
    t.string   "synopsis"
    t.integer  "service_id"
    t.string   "permalink"
    t.string   "subservice_header_icon_file_name"
    t.string   "subservice_header_icon_content_type"
    t.integer  "subservice_header_icon_file_size"
    t.datetime "subservice_header_icon_updated_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "second_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "remember_token_expires_at"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id",                   :default => 2
  end

end
