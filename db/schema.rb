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

ActiveRecord::Schema.define(version: 2021_03_12_180225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_accounts", force: :cascade do |t|
    t.integer "external_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_billing_accounts_on_external_id", unique: true
  end

  create_table "billing_money_types", force: :cascade do |t|
    t.string "sym_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sym_code"], name: "index_billing_money_types_on_sym_code", unique: true
  end

  create_table "billing_operations", force: :cascade do |t|
    t.integer "subject_id", null: false
    t.string "subject_type", null: false
    t.string "reason", null: false
    t.datetime "run_at", null: false
    t.json "context"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reason"], name: "index_billing_operations_on_reason"
    t.index ["subject_id"], name: "index_billing_operations_on_subject_id"
    t.index ["subject_type"], name: "index_billing_operations_on_subject_type"
  end

  create_table "billing_transactions", force: :cascade do |t|
    t.bigint "billing_account_id", null: false
    t.bigint "billing_operation_id", null: false
    t.bigint "billing_money_type_id", null: false
    t.float "amount", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["billing_account_id"], name: "index_billing_transactions_on_billing_account_id"
    t.index ["billing_money_type_id"], name: "index_billing_transactions_on_billing_money_type_id"
    t.index ["billing_operation_id"], name: "index_billing_transactions_on_billing_operation_id"
  end

  add_foreign_key "billing_transactions", "billing_accounts"
  add_foreign_key "billing_transactions", "billing_money_types"
  add_foreign_key "billing_transactions", "billing_operations"
end
