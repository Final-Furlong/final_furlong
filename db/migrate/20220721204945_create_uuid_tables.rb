class CreateUuidTables < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'

    create_table "new_racetracks", id: :uuid, force: :cascade do |t|
      t.string :name, null: false, index: true
      t.string :state, null: false, index: true
      t.string :country, null: false, index: true
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.timestamps
    end

    create_table "new_users", id: :uuid, force: :cascade do |t|
      t.string "username", null: false, index: { unique: true }
      t.enum "status", default: "pending", null: false, comment: "pending, active, deleted, banned", enum_type: "user_status", index: true
      t.string "name", null: false, comment: "displayed on profile"
      t.boolean "admin", default: false, null: false
      t.integer "discourse_id", comment: "integer from Discourse forum", index: { unique: true }
      t.string "email", default: "", null: false, index: { unique: true }
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token", index: { unique: true }
      t.datetime "reset_password_sent_at", precision: nil
      t.datetime "remember_created_at", precision: nil
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at", precision: nil
      t.datetime "last_sign_in_at", precision: nil
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "confirmation_token", index: { unique: true }
      t.datetime "confirmed_at", precision: nil
      t.datetime "confirmation_sent_at", precision: nil
      t.string "unconfirmed_email"
      t.integer "failed_attempts", default: 0, null: false
      t.string "unlock_token", index: { unique: true }
      t.datetime "locked_at", precision: nil
      t.datetime "discarded_at", index: true
      t.timestamps
    end

    create_table "new_stables", id: :uuid, force: :cascade do |t|
      t.string "name", null: false, index: { unique: true }
      t.uuid "user_id", index: true
      t.integer "legacy_id", index: { unique: true }
      t.text "description"
      t.timestamps
    end

    create_table "new_activations", id: :uuid, force: :cascade do |t|
      t.uuid "user_id", index: { unique: true }
      t.string "token", null: false
      t.datetime "activated_at"
      t.timestamps
    end

    create_table "new_horses", id: :uuid, force: :cascade do |t|
      t.string "name", index: { unique: true }
      t.string "gender", null: false, comment: "colt, filly, mare, stallion, gelding"
      t.enum "status", default: "unborn", null: false, comment: "unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased", enum_type: "horse_status", index: true
      t.date "date_of_birth", null: false, index: true
      t.date "date_of_death"
      t.uuid "owner_id", index: true
      t.uuid "breeder_id", index: true
      t.uuid "location_bred_id", index: true
      t.uuid "sire_id", index: true
      t.uuid "dam_id", index: true
      t.timestamps
      t.integer "old_id"
      t.integer "old_sire_id"
      t.integer "old_dam_id"
    end
  end
end
