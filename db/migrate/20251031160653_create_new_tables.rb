class CreateNewTables < ActiveRecord::Migration[8.1]
  def change
    drop_table :new_activations if table_exists? :new_activations
    drop_table :new_racetracks if table_exists? :new_racetracks
    drop_table :new_stables if table_exists? :new_stables

    create_table :new_activations do |t|
      t.datetime "activated_at", precision: nil
      t.string "token", null: false
      t.integer "user_id", index: { unique: true }
      t.uuid "old_user_id", null: false, index: { unique: true }

      t.timestamps
    end

    types_list = %w[
      color_war
      auction
      selling
      buying
      breeding
      claiming
      entering
      redeem
    ]

    create_table :new_activity_points do |t|
      t.enum :activity_type, enum_type: "activity_type", null: false, index: true, comment: types_list.join(", ")
      t.integer "amount", default: 0, null: false
      t.integer "balance", default: 0, limit: 8, null: false
      t.integer "budget_id", index: true
      t.uuid "old_budget_id", index: true
      t.integer "legacy_stable_id", default: 0, null: false, index: true
      t.integer "stable_id", index: true
      t.uuid "old_stable_id", null: false, index: true
      t.uuid "old_id", null: false, index: true

      t.timestamps
    end

    create_table :new_auction_bids do |t|
      t.integer "auction_id", index: true
      t.uuid "old_auction_id", null: false, index: true
      t.integer "bidder_id", index: true
      t.uuid "old_bidder_id", null: false, index: true
      t.text "comment"
      t.integer "current_bid", default: 0, null: false
      t.boolean "notify_if_outbid", default: false, null: false
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.integer "maximum_bid"
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_auction_consignment_configs do |t|
      t.integer "auction_id", index: true
      t.uuid "old_auction_id", null: false, index: true
      t.string "horse_type", null: false
      t.integer "maximum_age", default: 0, null: false
      t.integer "minimum_age", default: 0, null: false
      t.integer "minimum_count", default: 0, null: false
      t.boolean "stakes_quality", default: false, null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_auction_horses do |t|
      t.integer "auction_id", index: true
      t.uuid "old_auction_id", null: false, index: true
      t.text "comment"
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.integer "maximum_price"
      t.integer "reserve_price"
      t.datetime "sold_at", precision: nil, index: true
      t.string "public_id", limit: 12
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_auctions do |t|
      t.integer "auctioneer_id", index: true
      t.uuid "old_auctioneer_id", null: false, index: true
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
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_broodmare_foal_records do |t|
      t.integer "born_foals_count", default: 0, null: false, index: true
      t.string "breed_ranking", index: true
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.integer "millionaire_foals_count", default: 0, null: false, index: true
      t.integer "multi_millionaire_foals_count", default: 0, null: false, index: true
      t.integer "multi_stakes_winning_foals_count", default: 0, null: false, index: true
      t.integer "raced_foals_count", default: 0, null: false, index: true
      t.integer "stakes_winning_foals_count", default: 0, null: false, index: true
      t.integer "stillborn_foals_count", default: 0, null: false, index: true
      t.integer "total_foal_earnings", limit: 8, default: 0, null: false
      t.integer "total_foal_points", default: 0, null: false, index: true
      t.integer "total_foal_races", default: 0, null: false, index: true
      t.integer "unborn_foals_count", default: 0, null: false, index: true
      t.integer "winning_foals_count", default: 0, null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    budget_types_list = %w[
      sold_horse
      bought_horse
      bred_mare
      bred_stud
      claimed_horse
      entered_race
      shipped_horse
      race_winnings
      jockey_fee
      nominated_racehorse
      nominated_stallion
      boarded_horse
    ]
    create_enum :budget_activity_type, budget_types_list

    create_table :new_budget_transactions do |t|
      t.enum :activity_type, enum_type: "budget_activity_type", index: true, comment: budget_types_list.join(", ")
      t.integer "amount", default: 0, null: false
      t.integer "balance", default: 0, null: false
      t.text "description", null: false, index: true
      t.integer "legacy_budget_id", default: 0, index: true
      t.integer "legacy_stable_id", default: 0, index: true
      t.integer "stable_id", index: true
      t.uuid "old_stable_id", null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_game_activity_points do |t|
      t.enum :activity_type, enum_type: "activity_type", null: false, index: true, comment: types_list.join(", ")
      t.integer "first_year_points", default: 0, null: false
      t.integer "older_year_points", default: 0, null: false
      t.integer "second_year_points", default: 0, null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_game_alerts do |t|
      t.boolean "display_to_newbies", default: true, null: false, index: true
      t.boolean "display_to_non_newbies", default: true, null: false, index: true
      t.datetime "end_time", precision: nil, index: true
      t.text "message", null: false
      t.datetime "start_time", precision: nil, null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    color_list = %w[
      bay
      black
      blood_bay
      blue_roan
      brown
      chestnut
      dapple_grey
      dark_bay
      dark_grey
      flea_bitten_grey
      grey
      light_bay
      light_chestnut
      light_grey
      liver_chestnut
      mahogany_bay
      red_chestnut
      strawberry_roan
    ]
    leg_marking_list = %w[coronet ermine sock stocking]
    face_marking_list = %w[bald_face blaze snip star star_snip star_stripe star_stripe_snip stripe stripe_snip]

    create_table :new_horse_appearances do |t|
      t.decimal :birth_height, precision: 4, scale: 2, default: 0.0
      t.decimal :current_height, precision: 4, scale: 2, default: 0.0
      t.decimal :max_height, precision: 4, scale: 2, default: 0.0
      t.enum :color, enum_type: "horse_color", default: "bay", null: false, comment: color_list.join(", ")
      t.enum :rf_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :lf_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :rh_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :lh_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :face_marking, enum_type: "horse_face_marking", default: nil, comment: face_marking_list.join(", ")
      t.string "face_image"
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.string "lf_leg_image"
      t.string "lh_leg_image"
      t.string "rf_leg_image"
      t.string "rh_leg_image"
      t.uuid "old_id", index: true

      t.timestamps
    end

    breed_records = %w[none bronze silver gold platinum]
    create_enum :breed_record, breed_records

    create_table :new_horse_attributes do |t|
      t.string :track_record, default: "Unraced", null: false
      t.string :title
      t.enum :breeding_record, enum_type: "breed_record", default: "none", null: false, comment: breed_records.join(", ")
      t.string :dosage_text, :string
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_horse_genetics do |t|
      t.string "allele", limit: 32, null: false
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    status_list = %w[
      unborn
      weanling
      yearling
      racehorse
      broodmare
      stud
      retired
      retired_broodmare
      retired_stud
      deceased
    ]
    gender_list = %w[colt filly mare stallion gelding]

    create_table :new_horses do |t|
      t.string "public_id", limit: 12, index: true
      t.string "name", limit: 18, index: true
      t.string "slug", index: true
      t.date "date_of_birth", null: false, index: true
      t.date "date_of_death", index: true
      t.integer "age", default: 0, null: false, index: true
      t.enum :gender, enum_type: "horse_gender", null: false, index: true, comment: gender_list.join(", ")
      t.enum :status, enum_type: "horse_status", default: "unborn", null: false, index: true, comment: status_list.join(", ")
      t.integer "sire_id", index: true
      t.uuid "old_sire_id", index: true
      t.integer "dam_id", index: true
      t.uuid "old_dam_id", index: true
      t.integer "owner_id", index: true
      t.uuid "old_owner_id", null: false, index: true
      t.integer "breeder_id", index: true
      t.uuid "old_breeder_id", null: false, index: true
      t.integer "legacy_id", index: true
      t.integer "location_bred_id", index: true
      t.uuid "old_location_bred_id", null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    genders = %w[male female]
    statuses = %w[apprentice veteran retired]
    jockey_types = %w[flat jump]

    create_table :new_jockeys do |t|
      t.string "public_id", limit: 12, index: true
      t.string "first_name", null: false, index: true
      t.string "last_name", null: false, index: true
      t.date "date_of_birth", null: false, index: true
      t.enum :status, enum_type: "jockey_status", index: true, comment: statuses.join(", ")
      t.enum :jockey_type, enum_type: "jockey_type", index: true, comment: jockey_types.join(", ")
      t.integer "height_in_inches", null: false, index: true
      t.integer "weight", null: false, index: true
      t.string "slug", index: true
      t.enum :gender, enum_type: "jockey_gender", index: true, comment: genders.join(", ")
      t.integer "acceleration", null: false
      t.integer "average_speed", null: false
      t.integer "break_speed", null: false
      t.integer "closing", null: false
      t.integer "consistency", null: false
      t.integer "courage", null: false
      t.integer "dirt", null: false
      t.integer "experience", null: false
      t.integer "experience_rate", null: false
      t.integer "fast", null: false
      t.integer "good", null: false
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
      t.integer "steeplechase", null: false
      t.integer "strength", null: false
      t.integer "traffic", null: false
      t.integer "turf", null: false
      t.integer "turning", null: false
      t.integer "wet", null: false
      t.integer "whip_seconds", null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_locations do |t|
      t.string "country", null: false
      t.string "county"
      t.string "name", null: false, index: true
      t.string "state"
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_race_odds do |t|
      t.string "display", null: false, index: true
      t.decimal :value, precision: 3, scale: 1, null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    race_types = %w[dirt turf steeplechase]

    create_table :new_race_records do |t|
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.integer "year", default: 1996, null: false, index: true
      t.enum :result_type, enum_type: "race_result_types", default: "dirt", index: true, comment: race_types.join(", ")
      t.integer "starts", default: 0, null: false, index: true
      t.integer "stakes_starts", default: 0, null: false, index: true
      t.integer "wins", default: 0, null: false, index: true
      t.integer "stakes_wins", default: 0, null: false, index: true
      t.integer "seconds", default: 0, null: false
      t.integer "stakes_seconds", default: 0, null: false
      t.integer "thirds", default: 0, null: false
      t.integer "stakes_thirds", default: 0, null: false
      t.integer "fourths", default: 0, null: false
      t.integer "stakes_fourths", default: 0, null: false
      t.integer "points", default: 0, null: false
      t.integer "earnings", limit: 8, default: 0, null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_race_result_horses do |t|
      t.integer "race_id", index: true
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.integer "legacy_horse_id", default: 0, null: false, index: true
      t.integer "post_parade", default: 1, null: false
      t.integer "finish_position", default: 1, null: false, index: true
      t.string "positions", null: false
      t.string "margins", null: false
      t.string "fractions"
      t.integer "jockey_id", index: true
      t.uuid "old_jockey_id", index: true
      t.integer "equipment", default: 0, null: false # flag_shih_tzu-managed bit field
      # Effective booleans which will be stored on the equipment column:
      # t.boolean      :blinkers
      # t.boolean      :shadow_roll
      # t.boolean      :wraps
      # t.boolean      :figure_8
      # t.boolean      :no_whip
      t.integer "odd_id"
      t.uuid "old_odd_id", index: true
      t.uuid "old_race_id", null: false, index: true
      t.integer "speed_factor", default: 0, null: false, index: true
      t.integer "weight", default: 0, null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    types_list = %w[
      maiden
      claiming
      starter_allowance
      nw1_allowance
      nw2_allowance
      nw3_allowance
      allowance
      stakes
    ]
    ages_list = %w[2 2+ 3 3+ 4 4+]
    grades_list = ["Ungraded", "Grade 3", "Grade 2", "Grade 1"]
    track_conditions = %w[fast good slow wet]
    race_splits = %w[4Q 2F]

    create_table :new_race_results do |t|
      t.date "date", null: false, index: true
      t.integer "number", default: 1, null: false, index: true
      t.enum :race_type, enum_type: "race_type", default: "maiden", null: false, index: true, comment: types_list.join(", ")
      t.enum :age, enum_type: "race_age", default: "2", null: false, index: true, comment: ages_list.join(", ")
      t.boolean "male_only", default: false, null: false
      t.boolean "female_only", default: false, null: false
      t.decimal :distance, precision: 3, scale: 1, default: 5.0, null: false, index: true
      t.enum :grade, enum_type: "race_grade", index: true, comment: grades_list.join(", ")
      t.integer "surface_id", index: true
      t.uuid "old_surface_id", null: false, index: true
      t.enum :condition, enum_type: "track_condition", index: true, comment: track_conditions.join(", ")
      t.string "name", index: true
      t.integer :purse, limit: 8, default: 0, null: false, index: true
      t.integer "claiming_price"
      t.enum :split, enum_type: "race_splits", comment: race_splits.join(", ")
      t.decimal :time_in_seconds, precision: 7, scale: 3, default: 0.0, null: false, index: true
      t.string "slug", index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_race_schedules do |t|
      t.integer "day_number", default: 1, null: false, index: true
      t.date "date", null: false, index: true
      t.integer "number", default: 1, null: false, index: true
      t.enum :race_type, enum_type: "race_type", default: "maiden", null: false, index: true, comment: types_list.join(", ")
      t.enum :age, enum_type: "race_age", default: "2", null: false, index: true, comment: ages_list.join(", ")
      t.boolean "male_only", default: false, null: false, index: true
      t.boolean "female_only", default: false, null: false, index: true
      t.decimal :distance, precision: 3, scale: 1, default: 5.0, null: false, index: true
      t.enum :grade, enum_type: "race_grade", index: true, comment: grades_list.join(", ")
      t.integer "surface_id", index: true
      t.uuid "old_surface_id", null: false, index: true
      t.string "name", index: true
      t.integer "purse", limit: 8, default: 0, null: false
      t.integer "claiming_price"
      t.boolean "qualification_required", default: false, null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_racetracks do |t|
      t.string "name", null: false, index: { unique: true }
      t.string "slug", index: true
      t.string "public_id", limit: 12, index: true
      t.decimal "latitude", null: false
      t.decimal "longitude", null: false
      t.integer "location_id", index: true
      t.uuid "old_location_id", null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_sessions do |t|
      t.string "session_id", null: false, index: true
      t.integer "user_id", index: true
      t.uuid "old_user_id", index: true
      t.text "data"
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_settings do |t|
      t.integer "user_id", index: true
      t.uuid "old_user_id", null: false, index: true
      t.string "theme"
      t.string "locale"
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_stables do |t|
      t.string "name", null: false, index: { unique: true }
      t.integer "legacy_id", index: true
      t.string "slug", index: true
      t.string "public_id", limit: 12, index: true
      t.integer "available_balance", limit: 8, default: 0, index: true
      t.integer "total_balance", limit: 8, default: 0, index: true
      t.datetime "last_online_at", precision: nil, index: true
      t.text "description"
      t.integer "miles_from_track", default: 1, null: false
      t.integer "racetrack_id", index: true
      t.uuid "old_racetrack_id", index: true
      t.integer "user_id", index: true
      t.uuid "old_user_id", null: false, index: true
      t.uuid "old_id", null: false, index: true

      t.timestamps
    end

    surfaces = %w[dirt turf steeplechase]
    conditions = %w[fast good slow wet]

    create_table :new_track_surfaces do |t|
      t.enum :surface, enum_type: "track_surface", default: "dirt", null: false, comment: surfaces.join(', ')
      t.enum :condition, enum_type: "track_condition", default: "fast", null: false, comment: conditions.join(', ')
      t.integer "racetrack_id", index: true
      t.uuid "old_racetrack_id", null: false, index: true
      t.integer "banking", null: false
      t.integer "jumps", default: 0, null: false
      t.integer "length", null: false
      t.integer "turn_distance", null: false
      t.integer "turn_to_finish_length", null: false
      t.integer "width", null: false
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_training_schedules do |t|
      t.string "name", null: false
      t.integer "stable_id", index: true
      t.uuid "old_stable_id", null: false, index: true
      t.integer "horses_count", default: 0, null: false, index: true
      t.string "monday_activities", null: false, index: true
      t.string "tuesday_activities", null: false, index: true
      t.string "wednesday_activities", null: false, index: true
      t.string "thursday_activities", null: false, index: true
      t.string "friday_activities", null: false, index: true
      t.string "saturday_activities", null: false, index: true
      t.string "sunday_activities", null: false, index: true
      t.text "description"
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_training_schedules_horses do |t|
      t.integer "horse_id", index: true
      t.uuid "old_horse_id", null: false, index: true
      t.integer "training_schedule_id", index: true
      t.uuid "old_training_schedule_id", null: false, index: true
      t.uuid "old_id", index: true

      t.timestamps
    end

    create_table :new_user_push_subscriptions do |t|
      t.integer "user_id", index: true
      t.uuid "old_user_id", null: false, index: true
      t.string "user_agent"
      t.string "auth_key"
      t.string "endpoint"
      t.string "p256dh_key"
      t.uuid "old_id", index: true

      t.timestamps
    end

    user_statuses = %w[pending active deleted banned]

    create_table :new_users do |t|
      t.string "slug", index: { unique: true }
      t.string "username", null: false, index: true
      t.string "public_id", limit: 12, index: true
      t.enum :status, enum_type: "user_status", default: "pending", null: false, comment: user_statuses.join(', ')
      t.integer "discourse_id", index: { unique: true }
      t.string "email", default: "", null: false, index: { unique: true }
      t.string "name", null: false, index: true
      t.boolean "admin", default: false, null: false, index: true
      t.boolean "developer", default: false, null: false, index: true
      t.datetime "discarded_at", precision: nil
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at", precision: nil
      t.string "current_sign_in_ip"
      t.string "unconfirmed_email"
      t.datetime "remember_created_at", precision: nil
      t.integer "failed_attempts", default: 0, null: false
      t.datetime "last_sign_in_at", precision: nil
      t.string "last_sign_in_ip"
      t.datetime "locked_at", precision: nil
      t.string "unlock_token"
      t.datetime "reset_password_sent_at", precision: nil
      t.string "reset_password_token"
      t.datetime "confirmation_sent_at", precision: nil
      t.string "confirmation_token"
      t.datetime "confirmed_at", precision: nil
      t.string "encrypted_password", default: "", null: false
      t.uuid "old_id", index: true

      t.timestamps
    end
  end
end
