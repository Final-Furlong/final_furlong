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

ActiveRecord::Schema[7.0].define(version: 2022_04_03_152231) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "user_status", ["pending", "active", "deleted", "banned"]

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.enum "status", default: "pending", null: false, enum_type: "user_status"
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "admin", default: false, null: false
    t.integer "discourse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discourse_id"], name: "index_users_on_discourse_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
