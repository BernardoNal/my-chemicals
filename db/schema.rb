# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_05_26_205051) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "activities", force: :cascade do |t|
    t.date "date_start"
    t.date "date_end"
    t.text "description"
    t.string "activity_type", null: false
    t.string "area", null: false
    t.integer "forecast_days"
    t.text "resources"
    t.string "place"
    t.bigint "farm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_activities_on_farm_id"
  end

  create_table "activity_chemicals", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "chemical_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_chemicals_on_activity_id"
    t.index ["chemical_id"], name: "index_activity_chemicals_on_chemical_id"
  end

  create_table "cart_chemicals", force: :cascade do |t|
    t.bigint "chemical_id", null: false
    t.bigint "cart_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_chemicals_on_cart_id"
    t.index ["chemical_id"], name: "index_cart_chemicals_on_chemical_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "storage_id", null: false
    t.date "date_move"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "approver_id"
    t.bigint "requestor_id"
    t.string "description"
    t.index ["approver_id"], name: "index_carts_on_approver_id"
    t.index ["requestor_id"], name: "index_carts_on_requestor_id"
    t.index ["storage_id"], name: "index_carts_on_storage_id"
  end

  create_table "chemicals", force: :cascade do |t|
    t.string "product_name"
    t.string "compound_product"
    t.string "type_product"
    t.string "hazard"
    t.string "area"
    t.string "measurement_unit"
    t.integer "amount"
    t.float "dosage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.string "address"
    t.string "cpf"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.boolean "manager"
    t.boolean "invite"
    t.bigint "user_id", null: false
    t.bigint "farm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_employees_on_farm_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "farms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "size"
    t.string "cep"
    t.string "complement"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_farms_on_user_id"
  end

  create_table "responsibles", force: :cascade do |t|
    t.string "name"
    t.bigint "employee_id"
    t.bigint "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_responsibles_on_activity_id"
    t.index ["employee_id"], name: "index_responsibles_on_employee_id"
  end

  create_table "storages", force: :cascade do |t|
    t.bigint "farm_id", null: false
    t.string "name"
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_storages_on_farm_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "cpf"
    t.boolean "is_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "farms"
  add_foreign_key "activity_chemicals", "activities"
  add_foreign_key "activity_chemicals", "chemicals"
  add_foreign_key "cart_chemicals", "carts"
  add_foreign_key "cart_chemicals", "chemicals"
  add_foreign_key "carts", "storages"
  add_foreign_key "carts", "users", column: "approver_id"
  add_foreign_key "carts", "users", column: "requestor_id"
  add_foreign_key "employees", "farms"
  add_foreign_key "employees", "users"
  add_foreign_key "farms", "users"
  add_foreign_key "responsibles", "activities"
  add_foreign_key "responsibles", "employees", on_delete: :nullify
  add_foreign_key "storages", "farms"
end
