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

ActiveRecord::Schema[8.0].define(version: 2025_06_20_050513) do
  create_table "accounts", force: :cascade do |t|
    t.decimal "balance", precision: 11, scale: 2, default: "0.0", null: false
    t.string "cvu"
    t.string "alias"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "number", null: false
    t.date "issue_date"
    t.date "expiry_date"
    t.integer "payment_system", null: false
    t.string "cvv"
    t.integer "card_type", null: false
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_cards_on_account_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "owner_account_id", null: false
    t.integer "contact_account_id", null: false
    t.string "custom_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_account_id"], name: "index_contacts_on_contact_account_id"
    t.index ["owner_account_id", "contact_account_id"], name: "index_contacts_owner_and_contact", unique: true
    t.index ["owner_account_id"], name: "index_contacts_on_owner_account_id"
  end

  create_table "movements", force: :cascade do |t|
    t.decimal "amount", precision: 11, scale: 2
    t.date "movement_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id", null: false
    t.integer "transaction_id", null: false
    t.index ["account_id"], name: "index_movements_on_account_id"
    t.index ["transaction_id"], name: "index_movements_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 11, scale: 2
    t.integer "source_account_id"
    t.integer "target_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "description"
    t.index ["source_account_id"], name: "index_transactions_on_source_account_id"
    t.index ["target_account_id"], name: "index_transactions_on_target_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "dni"
    t.date "birth_date"
    t.string "phone"
    t.string "address"
    t.string "email"
    t.string "marital_status"
    t.string "legal_entity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "cards", "accounts"
  add_foreign_key "contacts", "accounts", column: "contact_account_id"
  add_foreign_key "contacts", "accounts", column: "owner_account_id"
  add_foreign_key "movements", "accounts"
  add_foreign_key "movements", "transactions"
  add_foreign_key "transactions", "accounts", column: "source_account_id"
  add_foreign_key "transactions", "accounts", column: "target_account_id"
end
