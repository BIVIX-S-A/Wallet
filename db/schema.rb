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

ActiveRecord::Schema[8.0].define(version: 2025_05_16_035541) do
  create_table "account", force: :cascade do |t|
    t.float "balance"
    t.string "cvu"
    t.string "alias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movements", force: :cascade do |t|
    t.integer "movement_id"
    t.float "amount"
    t.date "movement_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.integer "dni"
    t.date "birth_date"
    t.string "phone"
    t.string "address"
    t.string "email"
    t.integer "marital_status"
    t.boolean "legal_entity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
