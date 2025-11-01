class CreateNewTables < ActiveRecord::Migration[8.1]
  def change
    drop_table :new_activations if table_exists? :new_activations
    drop_table :new_racetracks if table_exists? :new_racetracks
    drop_table :new_stables if table_exists? :new_stables

    create_table :new_activations do |t|
      t.datetime "activated_at", precision: nil
      t.string "token", limit: 255, null: false
      t.integer "user_id", index: { unique: true }
      t.string "old_user_id", limit: 255, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :new_activity_points do |t|
      t.string "activity_type", limit: 255, null: false, index: true
      t.integer "amount", default: 0, null: false
      t.integer "balance", default: 0, null: false
      t.integer "budget_id", index: true
      t.string "old_budget_id", limit: 255, index: true
      t.integer "legacy_stable_id", default: 0, null: false, index: true
      t.integer "stable_id", index: true
      t.string "old_stable_id", limit: 255, null: false, index: true

      t.timestamps
    end

    create_table :new_auction_bids do |t|
      t.integer "auction_id", index: true
      t.string "old_auction_id", limit: 255, null: false, index: true
      t.integer "bidder_id", index: true
      t.string "old_bidder_id", limit: 255, null: false, index: true
      t.text "comment"
      t.integer "current_bid", default: 0, null: false
      t.boolean "notify_if_outbid", default: false, null: false
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false, index: true
      t.integer "maximum_bid"
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_auction_consignment_configs do |t|
      t.integer "auction_id", index: true
      t.string "old_auction_id", limit: 255, null: false, index: true
      t.string "horse_type", limit: 255, null: false
      t.integer "maximum_age", default: 0, null: false
      t.integer "minimum_age", default: 0, null: false
      t.integer "minimum_count", default: 0, null: false
      t.boolean "stakes_quality", default: false, null: false

      t.timestamps
    end

    create_table :new_auction_horses do |t|
      t.integer "auction_id", index: true
      t.string "old_auction_id", limit: 255, null: false, index: true
      t.text "comment"
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false, index: true
      t.integer "maximum_price"
      t.integer "reserve_price"
      t.datetime "sold_at", precision: nil, index: true
      t.string "public_id", limit: 12
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_auctions do |t|
      t.integer "auctioneer_id", index: true
      t.string "old_auctioneer_id", limit: 255, null: false, index: true
      t.boolean "broodmare_allowed", default: false, null: false
      t.datetime "end_time", precision: nil, null: false, index: true
      t.integer "horse_purchase_cap_per_stable"
      t.integer "hours_until_sold", default: 12, null: false
      t.boolean "outside_horses_allowed", default: false, null: false
      t.boolean "racehorse_allowed_2yo", default: false, null: false
      t.boolean "racehorse_allowed_3yo", default: false, null: false
      t.boolean "racehorse_allowed_older", default: false, null: false
      t.boolean "reserve_pricing_allowed", default: false, null: false
      t.integer "spending_cap_per_stable"
      t.boolean "stallion_allowed", default: false, null: false
      t.datetime "start_time", precision: nil, null: false, index: true
      t.string "title", limit: 500, null: false, index: { unique: true }
      t.boolean "weanling_allowed", default: false, null: false
      t.boolean "yearling_allowed", default: false, null: false
      t.string "public_id", limit: 12
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_broodmare_foal_records do |t|
      t.integer "born_foals_count", default: 0, null: false, index: true
      t.string "breed_ranking", limit: 255, index: true
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false, index: true
      t.integer "millionaire_foals_count", default: 0, null: false, index: true
      t.integer "multi_millionaire_foals_count", default: 0, null: false, index: true
      t.integer "multi_stakes_winning_foals_count", default: 0, null: false, index: true
      t.integer "raced_foals_count", default: 0, null: false, index: true
      t.integer "stakes_winning_foals_count", default: 0, null: false, index: true
      t.integer "stillborn_foals_count", default: 0, null: false, index: true
      t.bigint "total_foal_earnings", default: 0, null: false
      t.integer "total_foal_points", default: 0, null: false, index: true
      t.integer "total_foal_races", default: 0, null: false, index: true
      t.integer "unborn_foals_count", default: 0, null: false, index: true
      t.integer "winning_foals_count", default: 0, null: false, index: true

      t.timestamps
    end

    create_table :new_budget_transactions do |t|
      t.integer "amount", default: 0, null: false
      t.integer "balance", default: 0, null: false
      t.text "description", null: false, index: true
      t.integer "legacy_budget_id", default: 0, index: true
      t.integer "legacy_stable_id", default: 0, index: true
      t.integer "stable_id", index: true
      t.string "old_stable_id", limit: 255, null: false, index: true
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_game_activity_points do |t|
      t.string "activity_type", limit: 255, null: false, index: true
      t.integer "first_year_points", default: 0, null: false
      t.integer "older_year_points", default: 0, null: false
      t.integer "second_year_points", default: 0, null: false

      t.timestamps
    end

    create_table :new_game_alerts do |t|
      t.boolean "display_to_newbies", default: true, null: false, index: true
      t.boolean "display_to_non_newbies", default: true, null: false, index: true
      t.datetime "end_time", precision: nil, index: true
      t.text "message", null: false
      t.datetime "start_time", precision: nil, null: false, index: true

      t.timestamps
    end

    create_table :new_horse_appearances do |t|
      t.decimal "birth_height", default: "0.0", null: false
      t.string "color", limit: 255, default: "bay", null: false
      t.decimal "current_height", default: "0.0", null: false
      t.string "face_image", limit: 255
      t.string "face_marking", limit: 255
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false
      t.string "lf_leg_image", limit: 255
      t.string "lf_leg_marking", limit: 255
      t.string "lh_leg_image", limit: 255
      t.string "lh_leg_marking", limit: 255
      t.decimal "max_height", default: "0.0", null: false
      t.string "rf_leg_image", limit: 255
      t.string "rf_leg_marking", limit: 255
      t.string "rh_leg_image", limit: 255
      t.string "rh_leg_marking", limit: 255
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_horse_attributes do |t|
      t.string "breeding_record", limit: 255, default: "None", null: false, index: true
      t.string "dosage_text", limit: 255, index: true
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false
      t.string "title", limit: 255, index: true
      t.string "track_record", limit: 255, default: "Unraced", null: false, index: true
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_horse_genetics do |t|
      t.string "allele", limit: 32, null: false
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_horses do |t|
      t.integer "age"
      t.integer "breeder_id", index: true
      t.string "old_breeder_id", limit: 255, null: false, index: true
      t.integer "dam_id", index: true
      t.string "old_dam_id", limit: 255, index: true
      t.date "date_of_birth", null: false, index: true
      t.date "date_of_death", index: true
      t.string "gender", limit: 255, null: false
      t.integer "legacy_id", index: true
      t.integer "location_bred_id", index: true
      t.string "old_location_bred_id", limit: 255, null: false, index: true
      t.string "name", limit: 18, index: true
      t.integer "owner_id", index: true
      t.string "old_owner_id", limit: 255, null: false, index: true
      t.integer "sire_id", index: true
      t.string "old_sire_id", limit: 255, index: true
      t.string "slug", limit: 255, index: true
      t.string "status", limit: 255, default: "unborn", null: false, index: true
      t.string "public_id", limit: 12, index: true
      t.string "old_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_jockeys do |t|
      t.integer "acceleration", null: false
      t.integer "average_speed", null: false
      t.integer "break_speed", null: false
      t.integer "closing", null: false
      t.integer "consistency", null: false
      t.integer "courage", null: false
      t.date "date_of_birth", null: false, index: true
      t.integer "dirt", null: false
      t.integer "experience", null: false
      t.integer "experience_rate", null: false
      t.integer "fast", null: false
      t.string "first_name", limit: 255, null: false, index: true
      t.string "gender", limit: 255, index: true
      t.integer "good", null: false
      t.integer "height_in_inches", null: false, index: true
      t.string "jockey_type", limit: 255, index: true
      t.string "last_name", limit: 255, null: false, index: true
      t.integer "leading", null: false
      t.integer "legacy_id", null: false, index: true
      t.integer "loaf_threshold", null: false
      t.integer "looking", null: false
      t.integer "max_speed", null: false
      t.integer "midpack", null: false
      t.integer "min_speed", null: false
      t.integer "off_pace", null: false
      t.integer "pissy", null: false
      t.integer "rating", null: false
      t.integer "slow", null: false
      t.string "slug", limit: 255, index: true
      t.string "status", limit: 255, index: true
      t.integer "steeplechase", null: false
      t.integer "strength", null: false
      t.integer "traffic", null: false
      t.integer "turf", null: false
      t.integer "turning", null: false
      t.integer "weight", null: false, index: true
      t.integer "wet", null: false
      t.integer "whip_seconds", null: false
      t.string "public_id", limit: 12, index: true
      t.string "old_id", index: true

      t.timestamps
    end

    create_table :new_locations do |t|
      t.string "country", limit: 255, null: false
      t.string "county", limit: 255
      t.string "name", limit: 255, null: false, index: true
      t.string "state", limit: 255
      t.string "old_id", index: true

      t.timestamps
    end
    add_index :new_locations, %i[country name], unique: true

    create_table :new_race_odds do |t|
      t.string "display", limit: 255, null: false, index: true
      t.decimal "value", null: false, index: true
      t.string "old_id", index: true

      t.timestamps
    end

    create_table :new_race_records do |t|
      t.bigint "earnings", default: 0, null: false
      t.integer "fourths", default: 0, null: false
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false, index: true
      t.integer "points", default: 0, null: false
      t.string "result_type", limit: 255, default: "dirt", index: true
      t.integer "seconds", default: 0, null: false
      t.integer "stakes_fourths", default: 0, null: false
      t.integer "stakes_seconds", default: 0, null: false
      t.integer "stakes_starts", default: 0, null: false
      t.integer "stakes_thirds", default: 0, null: false
      t.integer "stakes_wins", default: 0, null: false
      t.integer "starts", default: 0, null: false
      t.integer "thirds", default: 0, null: false
      t.integer "wins", default: 0, null: false
      t.integer "year", default: 1996, null: false, index: true

      t.timestamps
    end

    create_table :new_race_result_horses do |t|
      t.integer "equipment", default: 0, null: false
      t.integer "finish_position", default: 1, null: false, index: true
      t.string "fractions", limit: 255
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false, index: true
      t.integer "jockey_id", index: true
      t.string "old_jockey_id", limit: 255, index: true
      t.integer "legacy_horse_id", default: 0, null: false, index: true
      t.string "margins", limit: 255, null: false
      t.string "odd_id", limit: 255
      t.string "positions", limit: 255, null: false
      t.integer "post_parade", default: 1, null: false
      t.integer "race_id", index: true
      t.string "old_race_id", limit: 255, null: false, index: true
      t.integer "speed_factor", default: 0, null: false, index: true
      t.integer "weight", default: 0, null: false

      t.timestamps
    end

    create_table :new_race_results do |t|
      t.string "age", limit: 255, default: "2", null: false
      t.integer "claiming_price"
      t.string "condition", limit: 255
      t.date "date", null: false, index: true
      t.decimal "distance", default: "5.0", null: false, index: true
      t.boolean "female_only", default: false, null: false
      t.string "grade", limit: 255, index: true
      t.boolean "male_only", default: false, null: false
      t.string "name", limit: 255, index: true
      t.integer "number", default: 1, null: false, index: true
      t.integer "purse", default: 0, null: false
      t.string "race_type", limit: 255, default: "maiden", null: false, index: true
      t.string "split", limit: 255
      t.integer "surface_id", index: true
      t.string "old_surface_id", limit: 255, null: false, index: true
      t.decimal "time_in_seconds", default: "0.0", null: false, index: true
      t.string "slug", index: true

      t.timestamps
    end

    create_table :new_race_schedules do |t|
      t.string "age", limit: 255, default: "2", null: false, index: true
      t.integer "claiming_price"
      t.date "date", null: false, index: true
      t.integer "day_number", default: 1, null: false, index: true
      t.decimal "distance", default: "5.0", null: false, index: true
      t.boolean "female_only", default: false, null: false, index: true
      t.string "grade", limit: 255, index: true
      t.boolean "male_only", default: false, null: false, index: true
      t.string "name", limit: 255, index: true
      t.integer "number", default: 1, null: false, index: true
      t.integer "purse", default: 0, null: false
      t.boolean "qualification_required", default: false, null: false, index: true
      t.string "race_type", limit: 255, default: "maiden", null: false, index: true
      t.integer "surface_id", index: true
      t.string "old_surface_id", limit: 255, null: false, index: true

      t.timestamps
    end

    create_table :new_racetracks do |t|
      t.decimal "latitude", null: false
      t.integer "location_id", index: true
      t.string "old_location_id", limit: 255, null: false, index: true
      t.decimal "longitude", null: false
      t.string "name", limit: 255, null: false, index: true
      t.string "slug", index: true
      t.string "public_id", limit: 12, index: true

      t.timestamps
    end

    create_table :new_sessions do |t|
      t.text "data"
      t.string "session_id", limit: 255, null: false, index: true
      t.integer "user_id", index: true
      t.string "old_user_id", limit: 255, index: true

      t.timestamps
    end

    create_table :new_settings do |t|
      t.string "locale", limit: 255
      t.string "theme", limit: 255
      t.integer "user_id", index: true
      t.string "old_user_id", limit: 255, null: false, index: true

      t.timestamps
    end

    create_table :new_stables do |t|
      t.integer "available_balance", default: 0, index: true
      t.text "description"
      t.datetime "last_online_at", precision: nil, index: true
      t.integer "legacy_id", index: true
      t.integer "miles_from_track", default: 1, null: false
      t.string "name", limit: 255, null: false, index: { unique: true }
      t.integer "racetrack_id", index: true
      t.string "old_racetrack_id", limit: 255, index: true
      t.integer "total_balance", default: 0, index: true
      t.integer "user_id", index: true
      t.string "old_user_id", limit: 255, null: false, index: true
      t.string "slug", index: true
      t.string "public_id", limit: 12, index: true

      t.timestamps
    end

    create_table :new_track_surfaces do |t|
      t.integer "banking", null: false
      t.string "condition", limit: 255, default: "fast", null: false, index: true
      t.integer "jumps", default: 0, null: false
      t.integer "length", null: false
      t.integer "racetrack_id", index: true
      t.string "old_racetrack_id", limit: 255, null: false, index: true
      t.string "surface", limit: 255, default: "dirt", null: false, index: true
      t.integer "turn_distance", null: false
      t.integer "turn_to_finish_length", null: false
      t.integer "width", null: false

      t.timestamps
    end

    create_table :new_training_schedules do |t|
      t.text "description"
      t.string "friday_activities", limit: 255, null: false, index: true
      t.integer "horses_count", default: 0, null: false, index: true
      t.string "monday_activities", limit: 255, null: false, index: true
      t.string "name", limit: 255, null: false
      t.string "saturday_activities", limit: 255, null: false, index: true
      t.integer "stable_id", index: true
      t.string "old_stable_id", limit: 255, null: false, index: true
      t.string "sunday_activities", limit: 255, null: false, index: true
      t.string "thursday_activities", limit: 255, null: false, index: true
      t.string "tuesday_activities", limit: 255, null: false, index: true
      t.string "wednesday_activities", limit: 255, null: false, index: true

      t.timestamps
    end

    create_table :new_training_schedules_horses do |t|
      t.integer "horse_id", index: true
      t.string "old_horse_id", limit: 255, null: false, index: true
      t.integer "training_schedule_id", index: true
      t.string "old_training_schedule_id", limit: 255, null: false, index: true

      t.timestamps
    end

    create_table :new_user_push_subscriptions do |t|
      t.string "auth_key", limit: 255
      t.string "endpoint", limit: 255
      t.string "p256dh_key", limit: 255
      t.string "user_agent", limit: 255
      t.integer "user_id", index: true
      t.string "old_user_id", limit: 255, null: false, index: true

      t.timestamps
    end

    create_table :new_users do |t|
      t.boolean "admin", default: false, null: false, index: true
      t.datetime "confirmation_sent_at", precision: nil
      t.string "confirmation_token", limit: 255
      t.datetime "confirmed_at", precision: nil
      t.datetime "current_sign_in_at", precision: nil
      t.string "current_sign_in_ip", limit: 255
      t.boolean "developer", default: false, null: false, index: true
      t.datetime "discarded_at", precision: nil
      t.integer "discourse_id", index: { unique: true }
      t.string "email", limit: 255, default: "", null: false, index: { unique: true }
      t.string "encrypted_password", limit: 255, default: "", null: false
      t.integer "failed_attempts", default: 0, null: false
      t.datetime "last_sign_in_at", precision: nil
      t.string "last_sign_in_ip", limit: 255
      t.datetime "locked_at", precision: nil
      t.string "name", limit: 255, null: false, index: true
      t.datetime "remember_created_at", precision: nil
      t.datetime "reset_password_sent_at", precision: nil
      t.string "reset_password_token", limit: 255
      t.integer "sign_in_count", default: 0, null: false
      t.string "slug", limit: 255, index: { unique: true }
      t.string "status", limit: 255, default: "pending", null: false, index: true
      t.string "unconfirmed_email", limit: 255
      t.string "unlock_token", limit: 255
      t.string "username", limit: 255, null: false, index: true
      t.string "public_id", limit: 12, index: true

      t.timestamps
    end
  end
end
