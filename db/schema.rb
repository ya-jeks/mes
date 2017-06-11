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

ActiveRecord::Schema.define(version: 20160128094105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chosen_products", force: :cascade do |t|
    t.integer  "session_id"
    t.integer  "product_id"
    t.text     "tech_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chosen_products", ["product_id"], name: "index_chosen_products_on_product_id", using: :btree
  add_index "chosen_products", ["session_id", "tech_path", "product_id"], name: "chosen_products_uniq_idx", unique: true, using: :btree
  add_index "chosen_products", ["session_id"], name: "index_chosen_products_on_session_id", using: :btree

  create_table "part_products", force: :cascade do |t|
    t.integer  "part_id",    null: false
    t.integer  "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "part_products", ["part_id", "product_id"], name: "index_part_products_on_part_id_and_product_id", unique: true, using: :btree
  add_index "part_products", ["part_id"], name: "index_part_products_on_part_id", using: :btree
  add_index "part_products", ["product_id"], name: "index_part_products_on_product_id", using: :btree

  create_table "parts", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_tasks", force: :cascade do |t|
    t.integer  "plan_id"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plan_tasks", ["plan_id"], name: "index_plan_tasks_on_plan_id", using: :btree
  add_index "plan_tasks", ["task_id"], name: "index_plan_tasks_on_task_id", using: :btree
  add_index "plan_tasks", ["task_id"], name: "pt_uniq_idx", unique: true, using: :btree

  create_table "plans", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plans", ["user_id"], name: "index_plans_on_user_id", using: :btree

  create_table "preset_variants", force: :cascade do |t|
    t.integer  "preset_id"
    t.text     "tech_path",  null: false
    t.integer  "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "preset_variants", ["preset_id"], name: "index_preset_variants_on_preset_id", using: :btree

  create_table "presets", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_presets", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "preset_id"
    t.boolean  "main",       default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "product_presets", ["preset_id"], name: "index_product_presets_on_preset_id", using: :btree
  add_index "product_presets", ["product_id"], name: "index_product_presets_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree

  create_table "recalcs", force: :cascade do |t|
    t.integer  "sku_id"
    t.integer  "uom_id"
    t.float    "qty",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "recalcs", ["sku_id", "uom_id"], name: "index_recalcs_on_sku_id_and_uom_id", unique: true, using: :btree
  add_index "recalcs", ["sku_id"], name: "index_recalcs_on_sku_id", using: :btree
  add_index "recalcs", ["uom_id"], name: "index_recalcs_on_uom_id", using: :btree

  create_table "residual_relations", force: :cascade do |t|
    t.integer  "task_id",     null: false
    t.integer  "residual_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "residual_relations", ["residual_id"], name: "index_residual_relations_on_residual_id", using: :btree
  add_index "residual_relations", ["task_id"], name: "index_residual_relations_on_task_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "sku_parts", force: :cascade do |t|
    t.integer  "sku_id",     null: false
    t.integer  "part_id",    null: false
    t.float    "qty",        null: false
    t.integer  "uom_id",     null: false
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sku_parts", ["part_id"], name: "index_sku_parts_on_part_id", using: :btree
  add_index "sku_parts", ["sku_id", "part_id", "uom_id", "name"], name: "up_uniq_idx", unique: true, using: :btree
  add_index "sku_parts", ["sku_id"], name: "index_sku_parts_on_sku_id", using: :btree

  create_table "sku_suppliers", force: :cascade do |t|
    t.integer  "sku_id",                  null: false
    t.integer  "supplier_id",             null: false
    t.integer  "duration",    default: 0, null: false
    t.float    "price",                   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "sku_suppliers", ["sku_id", "supplier_id"], name: "uv_uniq_idx", unique: true, using: :btree
  add_index "sku_suppliers", ["sku_id"], name: "index_sku_suppliers_on_sku_id", using: :btree
  add_index "sku_suppliers", ["supplier_id"], name: "index_sku_suppliers_on_supplier_id", using: :btree

  create_table "skus", force: :cascade do |t|
    t.integer  "product_id", null: false
    t.integer  "uom_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "skus", ["product_id", "uom_id"], name: "index_skus_on_product_id_and_uom_id", unique: true, using: :btree
  add_index "skus", ["product_id"], name: "index_skus_on_product_id", using: :btree
  add_index "skus", ["uom_id"], name: "index_skus_on_uom_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "code",                       null: false
    t.string   "address"
    t.boolean  "sales",      default: false, null: false
    t.integer  "capacity",   default: 0,     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "task_properties", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "product_id"
    t.float    "price",      null: false
    t.text     "tech_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "task_properties", ["product_id"], name: "index_task_properties_on_product_id", using: :btree
  add_index "task_properties", ["task_id", "tech_path"], name: "index_task_properties_on_task_id_and_tech_path", unique: true, using: :btree
  add_index "task_properties", ["task_id"], name: "index_task_properties_on_task_id", using: :btree

  create_table "task_relations", force: :cascade do |t|
    t.integer  "task_id",    null: false
    t.integer  "parent_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "task_relations", ["parent_id"], name: "index_task_relations_on_parent_id", using: :btree
  add_index "task_relations", ["task_id"], name: "index_task_relations_on_task_id", using: :btree

  create_table "task_srcs", force: :cascade do |t|
    t.integer  "task_id",    null: false
    t.integer  "src_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "task_srcs", ["task_id", "src_id"], name: "index_task_srcs_on_task_id_and_src_id", unique: true, using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sku_id"
    t.integer  "supplier_id",               null: false
    t.datetime "due_date"
    t.integer  "duration"
    t.string   "state",                     null: false
    t.float    "price",       default: 0.0, null: false
    t.float    "qty",                       null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "tasks", ["sku_id"], name: "index_tasks_on_sku_id", using: :btree
  add_index "tasks", ["state"], name: "index_tasks_on_state", using: :btree
  add_index "tasks", ["supplier_id"], name: "index_tasks_on_supplier_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "techs", force: :cascade do |t|
    t.text     "tech_path"
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uoms", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "uoms", ["name"], name: "index_uoms_on_name", unique: true, using: :btree

  create_table "user_suppliers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "supplier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_suppliers", ["supplier_id"], name: "index_user_suppliers_on_supplier_id", using: :btree
  add_index "user_suppliers", ["user_id"], name: "index_user_suppliers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "phone"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "variant_prices", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "tech_path",  null: false
    t.integer  "variant_id", null: false
    t.float    "price",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "variant_prices", ["product_id"], name: "index_variant_prices_on_product_id", using: :btree

  add_foreign_key "chosen_products", "products"
  add_foreign_key "part_products", "parts"
  add_foreign_key "part_products", "products"
  add_foreign_key "plans", "users"
  add_foreign_key "preset_variants", "presets"
  add_foreign_key "product_presets", "presets"
  add_foreign_key "product_presets", "products"
  add_foreign_key "recalcs", "skus"
  add_foreign_key "recalcs", "uoms"
  add_foreign_key "residual_relations", "tasks"
  add_foreign_key "residual_relations", "tasks", column: "residual_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "sku_parts", "parts"
  add_foreign_key "sku_parts", "skus"
  add_foreign_key "sku_parts", "uoms"
  add_foreign_key "sku_suppliers", "skus"
  add_foreign_key "sku_suppliers", "suppliers"
  add_foreign_key "skus", "products"
  add_foreign_key "skus", "uoms"
  add_foreign_key "task_properties", "products"
  add_foreign_key "task_relations", "tasks"
  add_foreign_key "task_relations", "tasks", column: "parent_id"
  add_foreign_key "task_srcs", "tasks"
  add_foreign_key "task_srcs", "tasks", column: "src_id"
  add_foreign_key "tasks", "skus"
  add_foreign_key "tasks", "suppliers"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_suppliers", "suppliers"
  add_foreign_key "user_suppliers", "users"
  add_foreign_key "variant_prices", "products"
end
