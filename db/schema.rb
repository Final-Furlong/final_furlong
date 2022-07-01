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

ActiveRecord::Schema[7.0].define(version: 2022_06_19_171138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "horse_gender", ["colt", "filly", "mare", "stallion", "gelding"]
  create_enum "horse_status", ["unborn", "weanling", "yearling", "racehorse", "broodmare", "stud", "retired", "retired_broodmare", "retired_stud", "deceased"]
  create_enum "user_status", ["pending", "active", "deleted", "banned"]

  create_table "horses", force: :cascade do |t|
    t.string "name"
    t.string "gender", null: false, comment: "colt, filly, mare, stallion, gelding"
    t.enum "status", default: "unborn", null: false, comment: "unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased", enum_type: "horse_status"
    t.date "date_of_birth", null: false
    t.date "date_of_death"
    t.bigint "owner_id"
    t.bigint "breeder_id"
    t.bigint "location_bred_id"
    t.bigint "sire_id"
    t.bigint "dam_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["breeder_id"], name: "index_horses_on_breeder_id"
    t.index ["dam_id"], name: "index_horses_on_dam_id"
    t.index ["date_of_birth"], name: "index_horses_on_date_of_birth"
    t.index ["location_bred_id"], name: "index_horses_on_location_bred_id"
    t.index ["owner_id"], name: "index_horses_on_owner_id"
    t.index ["sire_id"], name: "index_horses_on_sire_id"
    t.index ["status"], name: "index_horses_on_status"
  end

  create_table "racetracks", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.string "country"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country"], name: "index_racetracks_on_country"
    t.index ["latitude"], name: "index_racetracks_on_latitude"
    t.index ["longitude"], name: "index_racetracks_on_longitude"
    t.index ["name"], name: "index_racetracks_on_name", unique: true
  end

  create_table "stables", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stables_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.enum "status", default: "pending", null: false, comment: "pending, active, deleted, banned", enum_type: "user_status"
    t.string "name", null: false, comment: "displayed on profile"
    t.boolean "admin", default: false, null: false
    t.integer "discourse_id", comment: "integer from Discourse forum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.string "slug"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["discourse_id"], name: "index_users_on_discourse_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "horses", "horses", column: "dam_id"
  add_foreign_key "horses", "horses", column: "sire_id"
  add_foreign_key "horses", "racetracks", column: "location_bred_id"
  add_foreign_key "horses", "stables", column: "breeder_id"
  add_foreign_key "horses", "stables", column: "owner_id"
  add_foreign_key "stables", "users"
end
