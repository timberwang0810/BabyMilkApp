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

ActiveRecord::Schema.define(version: 2022_04_26_152224) do

  create_table "bottles", force: :cascade do |t|
    t.integer "patient_id"
    t.integer "checkin_nurse_id_id"
    t.integer "checkout_nurse_id_id"
    t.datetime "collected_date"
    t.string "storage_location"
    t.datetime "administration_date"
    t.datetime "expiration_date"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checkin_nurse_id_id"], name: "index_bottles_on_checkin_nurse_id_id"
    t.index ["checkout_nurse_id_id"], name: "index_bottles_on_checkout_nurse_id_id"
    t.index ["patient_id"], name: "index_bottles_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "patient_mrn"
    t.string "first_name"
    t.date "dob"
    t.string "last_name"
    t.integer "age"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admitted", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.boolean "active", default: true
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  create_table "visits", force: :cascade do |t|
    t.integer "patient_id"
    t.string "account_number"
    t.date "admission_date"
    t.date "discharge_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_visits_on_patient_id"
  end

end
