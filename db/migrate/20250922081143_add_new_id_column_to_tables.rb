class AddNewIdColumnToTables < ActiveRecord::Migration[8.0]
  def change
    create_table :new_activations, force: :cascade do |t|
      t.string "token", null: false
      t.uuid "user_id", null: false
      t.datetime "activated_at"

      t.timestamps
    end

    create_table :auctions, id: :uuid do |t|
      t.datetime "start_time", null: false
      t.datetime "end_time", null: false
      t.uuid "auctioneer_id"
      t.string "title", null: false
      t.integer "hours_until_sold", default: 12, null: false
      t.boolean "reserve_pricing_allowed", default: false, null: false
      t.boolean "outside_horses_allowed", default: false, null: false
      t.integer "spending_cap_per_stable"
      t.integer "horse_purchase_cap_per_stable"
      t.boolean "racehorse_allowed_2yo", default: false, null: false
      t.boolean "racehorse_allowed_3yo", default: false, null: false
      t.boolean "racehorse_allowed_older", default: false, null: false
      t.boolean "stallion_allowed", default: false, null: false
      t.boolean "broodmare_allowed", default: false, null: false
      t.boolean "yearling_allowed", default: false, null: false
      t.boolean "weanling_allowed", default: false, null: false

      t.timestamps
    end

    create_table :new_horse_appearances, id: :uuid do |t|
      t.uuid "horse_id"
      t.enum "color", default: "bay", null: false, comment: "bay, black, blood_bay, blue_roan, brown, chestnut, dapple_grey, dark_bay, dark_grey, flea_bitten_grey, grey, light_bay, light_chestnut, light_grey, liver_chestnut, mahogany_bay, red_chestnut, strawberry_roan", enum_type: "horse_color"
      t.enum "rf_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.enum "lf_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.enum "rh_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.enum "lh_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.enum "face_marking", comment: "bald_face, blaze, snip, star, star_snip, star_stripe, star_stripe_snip, stripe, stripe_snip", enum_type: "horse_face_marking"
      t.string "rf_leg_image"
      t.string "lf_leg_image"
      t.string "rh_leg_image"
      t.string "lh_leg_image"
      t.string "face_image"
      t.decimal "birth_height", precision: 4, scale: 2, default: "0.0"
      t.decimal "current_height", precision: 4, scale: 2, default: "0.0"
      t.decimal "max_height", precision: 4, scale: 2, default: "0.0"

      t.timestamps
    end

    create_table :new_horse_genetics, id: :uuid do |t|
      t.uuid "horse_id"
      t.string "allele", limit: 32

      t.timestamps
    end

    create_table :new_horses, id: :uuid do |t|
      t.string "name", limit: 18
      t.enum "gender", null: false, comment: "colt, filly, stallion, mare, gelding", enum_type: "horse_gender"
      t.enum "status", default: "unborn", null: false, comment: "unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased", enum_type: "horse_status"
      t.date "date_of_birth", null: false
      t.date "date_of_death"
      t.integer "age"
      t.uuid "owner_id", null: false
      t.uuid "breeder_id", null: false
      t.uuid "sire_id"
      t.uuid "dam_id"
      t.uuid "location_bred_id", null: false
      t.integer "legacy_id"
      t.integer "foals_count", default: 0, null: false
      t.integer "unborn_foals_count", default: 0, null: false

      t.timestamps
    end

    create_table :new_locations, id: :uuid do |t|
      t.string "name", null: false
      t.string "state"
      t.string "county"
      t.string "country", null: false

      t.timestamps
    end

    create_table :new_racetracks, id: :uuid do |t|
      t.string "name", null: false
      t.decimal "latitude", null: false
      t.decimal "longitude", null: false
      t.uuid "location_id", null: false

      t.timestamps
    end

    create_table :new_settings, id: :uuid do |t|
      t.string "theme"
      t.string "locale"
      t.uuid "user_id", null: false

      t.timestamps
    end

    create_table :new_stables, id: :uuid do |t|
      t.string "name", null: false
      t.uuid "user_id", null: false
      t.integer "legacy_id"
      t.text "description"
      t.integer "horses_count", default: 0, null: false
      t.integer "bred_horses_count", default: 0, null: false
      t.integer "unborn_horses_count", default: 0, null: false
      t.datetime "last_online_at"

      t.timestamps
    end

    create_table :new_track_surfaces, id: :uuid do |t|
      t.uuid "racetrack_id", null: false
      t.enum "surface", default: "dirt", null: false, comment: "dirt, turf, steeplechase", enum_type: "track_surface"
      t.enum "condition", default: "fast", null: false, comment: "fast, good, slow, wet", enum_type: "track_condition"
      t.integer "width", null: false
      t.integer "length", null: false
      t.integer "turn_to_finish_length", null: false
      t.integer "turn_distance", null: false
      t.integer "banking", null: false
      t.integer "jumps", default: 0, null: false

      t.timestamps
    end

    create_table :new_training_schedules, id: :uuid do |t|
      t.uuid "stable_id", null: false
      t.string "name", null: false
      t.text "description"
      t.jsonb "sunday_activities", default: {}, null: false
      t.jsonb "monday_activities", default: {}, null: false
      t.jsonb "tuesday_activities", default: {}, null: false
      t.jsonb "wednesday_activities", default: {}, null: false
      t.jsonb "thursday_activities", default: {}, null: false
      t.jsonb "friday_activities", default: {}, null: false
      t.jsonb "saturday_activities", default: {}, null: false
      t.integer "horses_count", default: 0, null: false

      t.timestamps
    end

    create_table :new_training_schedules_horses, force: :cascade do |t|
      t.uuid "training_schedule_id", null: false
      t.uuid "horse_id", null: false

      t.timestamps
    end

    create_table :new_users, id: :uuid do |t|
      t.string "slug"
      t.string "username", null: false
      t.enum "status", default: "pending", null: false, comment: "pending, active, deleted, banned", enum_type: "user_status"
      t.string "name", null: false
      t.boolean "admin", default: false, null: false
      t.integer "discourse_id", comment: "integer from Discourse forum"
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
      t.datetime "discarded_at"

      t.timestamps
    end
  end
end

