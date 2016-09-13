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

ActiveRecord::Schema.define(version: 20150914142857) do

  create_table "articles", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.text     "synopsis",             limit: 65535
    t.text     "body",                 limit: 65535
    t.boolean  "published",                          default: false
    t.datetime "published_at"
    t.integer  "category_id",          limit: 4
    t.integer  "user_id",              limit: 4
    t.string   "permalink",            limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "this_news",                          default: false
    t.string   "article_header_image", limit: 255
  end

  create_table "canvas_settings_paper_specifications", id: false, force: :cascade do |t|
    t.integer "canvas_setting_id",      limit: 4
    t.integer "paper_specification_id", limit: 4
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "permalink",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "order_id",                  limit: 4
    t.string   "docfile",                   limit: 255
    t.text     "user_comment",              limit: 65535
    t.integer  "quantity",                  limit: 4,     default: 1
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.float    "price",                     limit: 24,    default: 0.0
    t.string   "user_filename",             limit: 255
    t.integer  "document_specification_id", limit: 4
    t.integer  "page_count",                limit: 4,     default: 1
    t.integer  "paper_specification_id",    limit: 4
    t.float    "cost",                      limit: 24,    default: 0.0
    t.integer  "print_margin_id",           limit: 4
    t.integer  "print_color_id",            limit: 4
    t.integer  "binding_id",                limit: 4
  end

  create_table "documents_pre_print_operations", id: false, force: :cascade do |t|
    t.integer "document_id",            limit: 4
    t.integer "pre_print_operation_id", limit: 4
  end

  create_table "embedded_images", force: :cascade do |t|
    t.integer  "document_id", limit: 4
    t.string   "imgfile",     limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "letters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "phone",      limit: 255
    t.string   "email",      limit: 255
    t.text     "question",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "lists_bindings", force: :cascade do |t|
    t.string   "binding",    limit: 255
    t.float    "price",      limit: 24,  default: 0.0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "lists_canvas_settings", force: :cascade do |t|
    t.integer  "margin_top",  limit: 4, default: 0
    t.integer  "margin_left", limit: 4, default: 0
    t.integer  "width",       limit: 4, default: 100
    t.integer  "height",      limit: 4, default: 100
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "lists_delivery_towns", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.integer  "delivery_zone_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "lists_delivery_zones", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.float    "price",      limit: 24,  default: 0.0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "lists_order_statuses", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "key",        limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "lists_order_types", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "service_id",  limit: 4
    t.string   "description", limit: 255
  end

  create_table "lists_paper_densities", force: :cascade do |t|
    t.integer  "density",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "lists_paper_grades", force: :cascade do |t|
    t.string   "grade",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "lists_paper_sizes", force: :cascade do |t|
    t.string   "size",         limit: 255
    t.string   "size_iso_216", limit: 255
    t.integer  "width",        limit: 4
    t.integer  "length",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "lists_paper_specifications", force: :cascade do |t|
    t.integer  "paper_type_id", limit: 4
    t.integer  "paper_size_id", limit: 4
    t.boolean  "in_stock"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.float    "price",         limit: 24
    t.integer  "order_type_id", limit: 4,  default: 1
  end

  create_table "lists_paper_types", force: :cascade do |t|
    t.string   "paper_type",       limit: 255
    t.integer  "paper_grade_id",   limit: 4
    t.integer  "paper_density_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "lists_pre_print_operations", force: :cascade do |t|
    t.string   "operation",     limit: 255
    t.float    "price",         limit: 24,  default: 0.0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "order_type_id", limit: 4,   default: 1
  end

  create_table "lists_print_colors", force: :cascade do |t|
    t.string   "color",         limit: 255
    t.float    "price",         limit: 24,  default: 0.0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "order_type_id", limit: 4,   default: 1
  end

  create_table "lists_print_margins", force: :cascade do |t|
    t.string   "margin",        limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.float    "price",         limit: 24,  default: 0.0
    t.integer  "order_type_id", limit: 4,   default: 1
  end

  create_table "lists_product_backgrounds", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "image",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "lists_scan_specifications", force: :cascade do |t|
    t.integer  "paper_size_id", limit: 4
    t.float    "price",         limit: 24, default: 0.0
    t.integer  "order_type_id", limit: 4,  default: 1
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "mailings", force: :cascade do |t|
    t.string   "subject",      limit: 255
    t.text     "body",         limit: 65535
    t.integer  "sent_mails",   limit: 4,     default: 0
    t.integer  "all_mails",    limit: 4,     default: 0
    t.boolean  "published",                  default: false
    t.datetime "published_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "delivery_street",     limit: 255
    t.string   "delivery_address",    limit: 255
    t.date     "delivery_date"
    t.time     "delivery_start_time"
    t.time     "delivery_end_time"
    t.float    "cost",                limit: 24
    t.text     "manager_comment",     limit: 65535
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.float    "delivery_price",      limit: 24,    default: 0.0
    t.string   "delivery_type",       limit: 255
    t.integer  "order_status_id",     limit: 4
    t.integer  "order_type_id",       limit: 4
    t.integer  "delivery_town_id",    limit: 4
    t.float    "documents_price",     limit: 24,    default: 0.0
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.string   "permalink",     limit: 255
    t.text     "body",          limit: 65535
    t.boolean  "published",                   default: false
    t.datetime "published_at"
    t.integer  "user_id",       limit: 4
    t.integer  "section_id",    limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "service_id",    limit: 4
    t.integer  "subservice_id", limit: 4
    t.integer  "subsection_id", limit: 4
  end

  create_table "paper_specifications_product_backgrounds", id: false, force: :cascade do |t|
    t.integer "product_background_id",  limit: 4
    t.integer "paper_specification_id", limit: 4
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.string   "title",       limit: 255,   null: false
    t.text     "description", limit: 65535, null: false
    t.text     "the_role",    limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "controller", limit: 255
    t.string   "action",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "permalink",  limit: 255
    t.string   "ancestry",   limit: 255
    t.integer  "position",   limit: 4
  end

  add_index "sections", ["ancestry"], name: "index_sections_on_ancestry", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "synopsis",    limit: 255
    t.string   "permalink",   limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "pricelist",   limit: 255
    t.string   "header_icon", limit: 255
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "subservices", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "synopsis",    limit: 255
    t.integer  "service_id",  limit: 4
    t.string   "permalink",   limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "header_icon", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "second_name",            limit: 255
    t.string   "phone",                  limit: 255
    t.integer  "role_id",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
