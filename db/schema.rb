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

ActiveRecord::Schema[7.0].define(version: 2022_07_31_171155) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "horse_gender", ["colt", "filly", "mare", "stallion", "gelding"]
  create_enum "horse_status", ["unborn", "weanling", "yearling", "racehorse", "broodmare", "stud", "retired", "retired_broodmare", "retired_stud", "deceased"]
  create_enum "user_status", ["pending", "active", "deleted", "banned"]

  create_table "activations", force: :cascade do |t|
    t.datetime "activated_at"
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_activations_on_user_id", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "horses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "age"
    t.uuid "breeder_id", null: false
    t.datetime "created_at", null: false
    t.uuid "dam_id"
    t.date "date_of_birth", null: false
    t.date "date_of_death"
    t.enum "gender", null: false, comment: "colt, filly, stallion, mare, gelding", enum_type: "horse_gender"
    t.uuid "location_bred_id", null: false
    t.string "name"
    t.uuid "owner_id", null: false
    t.uuid "sire_id"
    t.enum "status", default: "unborn", null: false, comment: "unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased", enum_type: "horse_status"
    t.datetime "updated_at", null: false
    t.index ["breeder_id"], name: "index_horses_on_breeder_id"
    t.index ["created_at"], name: "index_horses_on_created_at"
    t.index ["dam_id"], name: "index_horses_on_dam_id"
    t.index ["date_of_birth"], name: "index_horses_on_date_of_birth"
    t.index ["location_bred_id"], name: "index_horses_on_location_bred_id"
    t.index ["owner_id"], name: "index_horses_on_owner_id"
    t.index ["sire_id"], name: "index_horses_on_sire_id"
    t.index ["status"], name: "index_horses_on_status"
  end

  create_table "racetracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "name", null: false
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["country"], name: "index_racetracks_on_country"
    t.index ["created_at"], name: "index_racetracks_on_created_at"
    t.index ["latitude"], name: "index_racetracks_on_latitude"
    t.index ["longitude"], name: "index_racetracks_on_longitude"
    t.index ["name"], name: "index_racetracks_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "data"
    t.string "session_id", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
    t.index ["user_id"], name: "index_sessions_on_user_id", unique: true
  end

  create_table "settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale"
    t.string "theme"
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_settings_on_user_id", unique: true
  end

  create_table "stables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "legacy_id"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["created_at"], name: "index_stables_on_created_at"
    t.index ["legacy_id"], name: "index_stables_on_legacy_id"
    t.index ["user_id"], name: "index_stables_on_user_id", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.datetime "discarded_at"
    t.integer "discourse_id", comment: "integer from Discourse forum"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "locked_at", precision: nil
    t.string "name", null: false
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "slug"
    t.enum "status", default: "pending", null: false, comment: "pending, active, deleted, banned", enum_type: "user_status"
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["discourse_id"], name: "index_users_on_discourse_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "activations", "users"
  add_foreign_key "horses", "horses", column: "dam_id"
  add_foreign_key "horses", "horses", column: "sire_id"
  add_foreign_key "horses", "racetracks", column: "location_bred_id"
  add_foreign_key "horses", "stables", column: "breeder_id"
  add_foreign_key "horses", "stables", column: "owner_id"
  add_foreign_key "settings", "users"
  add_foreign_key "stables", "users"
end
