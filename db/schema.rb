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

ActiveRecord::Schema.define(:version => 20131221144729) do

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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "documents", :force => true do |t|
    t.integer  "order_id"
    t.string   "docfile"
    t.text     "user_comment"
    t.integer  "quantity"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.float    "price"
    t.string   "user_filename"
    t.integer  "document_specification_id"
  end

  create_table "letters", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.text     "question"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lists_document_specifications", :force => true do |t|
    t.integer  "paper_specification_id"
    t.integer  "print_margin_id"
    t.boolean  "available",              :default => true
    t.float    "price"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "lists_order_statuses", :force => true do |t|
    t.string   "title"
    t.integer  "key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lists_paper_grades", :force => true do |t|
    t.string   "grade"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lists_paper_sizes", :force => true do |t|
    t.string   "size"
    t.string   "size_iso_216"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "lists_paper_specifications", :force => true do |t|
    t.integer  "paper_type_id"
    t.integer  "paper_size_id"
    t.boolean  "in_stock"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "lists_paper_types", :force => true do |t|
    t.string   "paper_type"
    t.integer  "paper_grade_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "lists_print_margins", :force => true do |t|
    t.string   "margin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mailings", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "sent_mails",   :default => 0
    t.integer  "all_mails",    :default => 0
    t.boolean  "published",    :default => false
    t.datetime "published_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "delivery_street"
    t.string   "delivery_address"
    t.date     "delivery_date"
    t.time     "delivery_start_time"
    t.time     "delivery_end_time"
    t.float    "cost"
    t.text     "manager_comment"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.float    "delivery_price"
    t.string   "delivery_type"
    t.float    "cost_min"
    t.float    "cost_max"
    t.string   "order_type"
    t.integer  "order_status_id"
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

  create_table "pricelist_deliveries", :force => true do |t|
    t.string   "delivery_type"
    t.float    "price"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "territory"
    t.string   "delivery_limit_time"
  end

  create_table "pricelist_scans", :force => true do |t|
    t.string   "work_name"
    t.string   "work_desc"
    t.float    "price_min",  :default => 0.0
    t.float    "price_max",  :default => 0.0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
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

  create_table "scans", :force => true do |t|
    t.integer  "order_id"
    t.integer  "scan_documents_quantity",            :default => 1
    t.integer  "base_correction_documents_quantity", :default => 0
    t.integer  "coloring_documents_quantity",        :default => 0
    t.integer  "restoration_documents_quantity",     :default => 0
    t.float    "cost_min"
    t.float    "cost_max"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
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
    t.string   "pricelist"
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
