class Create2025Structure < ActiveRecord::Migration[8.1]
  def change
    return unless Rails.env.local?
    return if table_exists?(:boardings)

    # These are extensions that must be enabled in order to support this database
    enable_extension "pg_catalog.plpgsql"
    enable_extension "pg_stat_statements"
    enable_extension "pgcrypto"

    # Custom types defined in this database.
    # Note that some types may not work with other database engines. Be careful if changing database.
    create_enum "activity_type", ["color_war", "auction", "selling", "buying", "breeding", "claiming", "entering", "redeem"]
    create_enum "breed_rankings", ["bronze", "silver", "gold", "platinum"]
    create_enum "breed_record", ["none", "bronze", "silver", "gold", "platinum"]
    create_enum "budget_activity_type", ["sold_horse", "bought_horse", "bred_mare", "bred_stud", "claimed_horse", "entered_race", "shipped_horse", "race_winnings", "jockey_fee", "nominated_racehorse", "nominated_stallion", "boarded_horse", "opening_balance", "paid_tax", "handicapping_races", "nominated_breeders_series", "consigned_auction", "leased_horse", "color_war", "activity_points", "donation", "won_breeders_series", "misc"]
    create_enum "horse_color", ["bay", "black", "blood_bay", "blue_roan", "brown", "chestnut", "dapple_grey", "dark_bay", "dark_grey", "flea_bitten_grey", "grey", "light_bay", "light_chestnut", "light_grey", "liver_chestnut", "mahogany_bay", "red_chestnut", "strawberry_roan"]
    create_enum "horse_face_marking", ["bald_face", "blaze", "snip", "star", "star_snip", "star_stripe", "star_stripe_snip", "stripe", "stripe_snip"]
    create_enum "horse_gender", ["colt", "filly", "mare", "stallion", "gelding"]
    create_enum "horse_leg_marking", ["coronet", "ermine", "sock", "stocking"]
    create_enum "horse_status", ["unborn", "weanling", "yearling", "racehorse", "broodmare", "stud", "retired", "retired_broodmare", "retired_stud", "deceased"]
    create_enum "jockey_gender", ["male", "female"]
    create_enum "jockey_status", ["apprentice", "veteran", "retired"]
    create_enum "jockey_type", ["flat", "jump"]
    create_enum "race_age", ["2", "2+", "3", "3+", "4", "4+"]
    create_enum "race_grade", ["Ungraded", "Grade 3", "Grade 2", "Grade 1"]
    create_enum "race_result_types", ["dirt", "turf", "steeplechase"]
    create_enum "race_splits", ["4Q", "2F"]
    create_enum "race_type", ["maiden", "claiming", "starter_allowance", "nw1_allowance", "nw2_allowance", "nw3_allowance", "allowance", "stakes"]
    create_enum "track_condition", ["fast", "good", "slow", "wet"]
    create_enum "track_surface", ["dirt", "turf", "steeplechase"]
    create_enum "user_status", ["pending", "active", "deleted", "banned"]

    create_table "activations" do |t|
      t.datetime "activated_at", precision: nil
      t.datetime "created_at", null: false
      t.string "token", null: false
      t.datetime "updated_at", null: false
      t.bigint "user_id", null: false
      t.index ["user_id"], name: "index_activations_on_user_id", unique: true
    end

    create_table "active_storage_attachments" do |t|
      t.bigint "blob_id", null: false
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.string "name", null: false
      t.bigint "record_id", null: false
      t.string "record_type", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end

    create_table "active_storage_blobs" do |t|
      t.bigint "byte_size", null: false
      t.string "checksum"
      t.string "content_type"
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.string "filename", null: false
      t.string "key", null: false
      t.text "metadata"
      t.string "service_name", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end

    # rubocop:disable Rails/CreateTableWithTimestamps
    create_table "active_storage_variant_records" do |t|
      t.bigint "blob_id", null: false
      t.string "variation_digest", null: false
      t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    end
    # rubocop:enable Rails/CreateTableWithTimestamps

    create_table "activity_points" do |t|
      t.enum "activity_type", null: false, comment: "color_war, auction, selling, buying, breeding, claiming, entering, redeem", enum_type: "activity_type"
      t.integer "amount", default: 0, null: false
      t.bigint "balance", default: 0, null: false
      t.bigint "budget_id"
      t.datetime "created_at", null: false
      t.integer "legacy_stable_id", default: 0, null: false
      t.bigint "stable_id", null: false
      t.datetime "updated_at", null: false
      t.index ["activity_type"], name: "index_activity_points_on_activity_type"
      t.index ["budget_id"], name: "index_activity_points_on_budget_id"
      t.index ["legacy_stable_id"], name: "index_activity_points_on_legacy_stable_id"
      t.index ["stable_id"], name: "index_activity_points_on_stable_id"
    end

    create_table "auction_bids" do |t|
      t.bigint "auction_id", null: false
      t.bigint "bidder_id", null: false
      t.text "comment"
      t.datetime "created_at", null: false
      t.integer "current_bid", default: 0, null: false
      t.bigint "horse_id", null: false
      t.integer "maximum_bid"
      t.boolean "notify_if_outbid", default: false, null: false
      t.datetime "updated_at", null: false
      t.index ["auction_id"], name: "index_auction_bids_on_auction_id"
      t.index ["bidder_id"], name: "index_auction_bids_on_bidder_id"
      t.index ["horse_id"], name: "index_auction_bids_on_horse_id"
    end

    create_table "auction_consignment_configs" do |t|
      t.bigint "auction_id", null: false
      t.datetime "created_at", null: false
      t.string "horse_type", null: false
      t.integer "maximum_age", default: 0, null: false
      t.integer "minimum_age", default: 0, null: false
      t.integer "minimum_count", default: 0, null: false
      t.boolean "stakes_quality", default: false, null: false
      t.datetime "updated_at", null: false
      t.index "auction_id, lower((horse_type)::text)", name: "index_auction_configs_on_horse_type", unique: true
      t.index ["auction_id"], name: "index_auction_consignment_configs_on_auction_id"
    end

    create_table "auction_horses" do |t|
      t.bigint "auction_id", null: false
      t.text "comment"
      t.datetime "created_at", null: false
      t.bigint "horse_id", null: false
      t.integer "maximum_price"
      t.string "public_id", limit: 12
      t.integer "reserve_price"
      t.string "slug"
      t.datetime "sold_at", precision: nil
      t.datetime "updated_at", null: false
      t.index ["auction_id"], name: "index_auction_horses_on_auction_id"
      t.index ["horse_id"], name: "index_auction_horses_on_horse_id", unique: true
      t.index ["slug"], name: "index_auction_horses_on_slug", unique: true
      t.index ["sold_at"], name: "index_auction_horses_on_sold_at"
    end

    create_table "auctions" do |t|
      t.bigint "auctioneer_id", null: false
      t.boolean "broodmare_allowed", default: false, null: false
      t.datetime "created_at", null: false
      t.datetime "end_time", precision: nil, null: false
      t.integer "horse_purchase_cap_per_stable"
      t.integer "hours_until_sold", default: 12, null: false
      t.boolean "outside_horses_allowed", default: false, null: false
      t.string "public_id", limit: 12
      t.boolean "racehorse_allowed_2yo", default: false, null: false
      t.boolean "racehorse_allowed_3yo", default: false, null: false
      t.boolean "racehorse_allowed_older", default: false, null: false
      t.boolean "reserve_pricing_allowed", default: false, null: false
      t.string "slug"
      t.integer "spending_cap_per_stable"
      t.boolean "stallion_allowed", default: false, null: false
      t.datetime "start_time", precision: nil, null: false
      t.string "title", limit: 500, null: false
      t.datetime "updated_at", null: false
      t.boolean "weanling_allowed", default: false, null: false
      t.boolean "yearling_allowed", default: false, null: false
      t.index "lower((title)::text)", name: "index_auctions_on_title", unique: true
      t.index ["auctioneer_id"], name: "index_auctions_on_auctioneer_id"
      t.index ["end_time"], name: "index_auctions_on_end_time"
      t.index ["slug"], name: "index_auctions_on_slug", unique: true
      t.index ["start_time"], name: "index_auctions_on_start_time"
    end

    create_table "boardings", id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.datetime "created_at", null: false
      t.integer "days", default: 0, null: false
      t.date "end_date"
      t.bigint "horse_id", null: false
      t.bigint "location_id", null: false
      t.date "start_date", null: false
      t.datetime "updated_at", null: false
      t.index ["end_date"], name: "index_boardings_on_end_date"
      t.index ["horse_id", "location_id", "start_date"], name: "index_boardings_on_horse_id_and_location_id_and_start_date", unique: true
      t.index ["location_id"], name: "index_boardings_on_location_id"
      t.index ["start_date"], name: "index_boardings_on_start_date"
    end

    create_table "broodmare_foal_records" do |t|
      t.integer "born_foals_count", default: 0, null: false
      t.string "breed_ranking"
      t.datetime "created_at", null: false
      t.bigint "horse_id", null: false
      t.integer "millionaire_foals_count", default: 0, null: false
      t.integer "multi_millionaire_foals_count", default: 0, null: false
      t.integer "multi_stakes_winning_foals_count", default: 0, null: false
      t.integer "raced_foals_count", default: 0, null: false
      t.integer "stakes_winning_foals_count", default: 0, null: false
      t.integer "stillborn_foals_count", default: 0, null: false
      t.bigint "total_foal_earnings", default: 0, null: false
      t.integer "total_foal_points", default: 0, null: false
      t.integer "total_foal_races", default: 0, null: false
      t.integer "unborn_foals_count", default: 0, null: false
      t.datetime "updated_at", null: false
      t.integer "winning_foals_count", default: 0, null: false
      t.index ["born_foals_count"], name: "index_broodmare_foal_records_on_born_foals_count"
      t.index ["breed_ranking"], name: "index_broodmare_foal_records_on_breed_ranking"
      t.index ["horse_id"], name: "index_broodmare_foal_records_on_horse_id", unique: true
      t.index ["millionaire_foals_count"], name: "index_broodmare_foal_records_on_millionaire_foals_count"
      t.index ["multi_millionaire_foals_count"], name: "index_broodmare_foal_records_on_multi_millionaire_foals_count"
      t.index ["multi_stakes_winning_foals_count"], name: "idx_on_multi_stakes_winning_foals_count_d86a3500a8"
      t.index ["raced_foals_count"], name: "index_broodmare_foal_records_on_raced_foals_count"
      t.index ["stakes_winning_foals_count"], name: "index_broodmare_foal_records_on_stakes_winning_foals_count"
      t.index ["stillborn_foals_count"], name: "index_broodmare_foal_records_on_stillborn_foals_count"
      t.index ["total_foal_points"], name: "index_broodmare_foal_records_on_total_foal_points"
      t.index ["total_foal_races"], name: "index_broodmare_foal_records_on_total_foal_races"
      t.index ["unborn_foals_count"], name: "index_broodmare_foal_records_on_unborn_foals_count"
      t.index ["winning_foals_count"], name: "index_broodmare_foal_records_on_winning_foals_count"
    end

    create_table "budget_transactions" do |t|
      t.enum "activity_type", comment: "sold_horse, bought_horse, bred_mare, bred_stud, claimed_horse, entered_race, shipped_horse, race_winnings, jockey_fee, nominated_racehorse, nominated_stallion, boarded_horse", enum_type: "budget_activity_type"
      t.integer "amount", default: 0, null: false
      t.integer "balance", default: 0, null: false
      t.datetime "created_at", null: false
      t.text "description", null: false
      t.integer "legacy_budget_id", default: 0
      t.integer "legacy_stable_id", default: 0
      t.bigint "stable_id", null: false
      t.datetime "updated_at", null: false
      t.index ["activity_type"], name: "index_budget_transactions_on_activity_type"
      t.index ["description"], name: "index_budget_transactions_on_description"
      t.index ["legacy_budget_id"], name: "index_budget_transactions_on_legacy_budget_id"
      t.index ["legacy_stable_id"], name: "index_budget_transactions_on_legacy_stable_id"
      t.index ["stable_id"], name: "index_budget_transactions_on_stable_id"
    end

    create_table "game_activity_points" do |t|
      t.enum "activity_type", null: false, comment: "color_war, auction, selling, buying, breeding, claiming, entering, redeem", enum_type: "activity_type"
      t.datetime "created_at", null: false
      t.integer "first_year_points", default: 0, null: false
      t.integer "older_year_points", default: 0, null: false
      t.integer "second_year_points", default: 0, null: false
      t.datetime "updated_at", null: false
      t.index ["activity_type"], name: "index_game_activity_points_on_activity_type"
    end

    create_table "game_alerts" do |t|
      t.datetime "created_at", null: false
      t.boolean "display_to_newbies", default: true, null: false
      t.boolean "display_to_non_newbies", default: true, null: false
      t.datetime "end_time", precision: nil
      t.text "message", null: false
      t.datetime "start_time", precision: nil, null: false
      t.datetime "updated_at", null: false
      t.index ["display_to_newbies"], name: "index_game_alerts_on_display_to_newbies"
      t.index ["display_to_non_newbies"], name: "index_game_alerts_on_display_to_non_newbies"
      t.index ["end_time"], name: "index_game_alerts_on_end_time"
      t.index ["start_time"], name: "index_game_alerts_on_start_time"
    end

    create_table "horse_appearances" do |t|
      t.decimal "birth_height", precision: 4, scale: 2, default: "0.0", null: false
      t.enum "color", default: "bay", null: false, comment: "bay, black, blood_bay, blue_roan, brown, chestnut, dapple_grey, dark_bay, dark_grey, flea_bitten_grey, grey, light_bay, light_chestnut, light_grey, liver_chestnut, mahogany_bay, red_chestnut, strawberry_roan", enum_type: "horse_color"
      t.datetime "created_at", null: false
      t.decimal "current_height", precision: 4, scale: 2, default: "0.0", null: false
      t.string "face_image"
      t.enum "face_marking", comment: "bald_face, blaze, snip, star, star_snip, star_stripe, star_stripe_snip, stripe, stripe_snip", enum_type: "horse_face_marking"
      t.bigint "horse_id", null: false
      t.string "lf_leg_image"
      t.enum "lf_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.string "lh_leg_image"
      t.enum "lh_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.decimal "max_height", precision: 4, scale: 2, default: "0.0", null: false
      t.string "rf_leg_image"
      t.enum "rf_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.string "rh_leg_image"
      t.enum "rh_leg_marking", comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.datetime "updated_at", null: false
      t.index ["horse_id"], name: "index_horse_appearances_on_horse_id", unique: true
      t.check_constraint "current_height >= birth_height", name: "current_height_must_be_valid"
      t.check_constraint "max_height >= current_height", name: "max_height_must_be_valid"
    end

    create_table "horse_attributes" do |t|
      t.enum "breeding_record", default: "none", null: false, comment: "none, bronze, silver, gold, platinum", enum_type: "breed_record"
      t.datetime "created_at", null: false
      t.string "dosage_text"
      t.bigint "horse_id", null: false
      t.string "string"
      t.string "title"
      t.string "track_record", default: "Unraced", null: false
      t.datetime "updated_at", null: false
      t.index ["horse_id"], name: "index_horse_attributes_on_horse_id", unique: true
    end

    create_table "horse_genetics" do |t|
      t.string "allele", limit: 32, null: false
      t.datetime "created_at", null: false
      t.bigint "horse_id", null: false
      t.datetime "updated_at", null: false
      t.index ["horse_id"], name: "index_horse_genetics_on_horse_id", unique: true
    end

    create_table "horses" do |t|
      t.integer "age", default: 0, null: false
      t.bigint "breeder_id", null: false
      t.datetime "created_at", null: false
      t.bigint "dam_id"
      t.date "date_of_birth", null: false
      t.date "date_of_death"
      t.enum "gender", null: false, comment: "colt, filly, mare, stallion, gelding", enum_type: "horse_gender"
      t.integer "legacy_id"
      t.bigint "location_bred_id", null: false
      t.string "name", limit: 18
      t.bigint "owner_id", null: false
      t.string "public_id", limit: 12
      t.bigint "sire_id"
      t.string "slug"
      t.enum "status", default: "unborn", null: false, comment: "unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased", enum_type: "horse_status"
      t.datetime "updated_at", null: false
      t.index ["age"], name: "index_horses_on_age"
      t.index ["breeder_id"], name: "index_horses_on_breeder_id"
      t.index ["dam_id"], name: "index_horses_on_dam_id"
      t.index ["date_of_birth"], name: "index_horses_on_date_of_birth"
      t.index ["date_of_death"], name: "index_horses_on_date_of_death"
      t.index ["gender"], name: "index_horses_on_gender"
      t.index ["legacy_id"], name: "index_horses_on_legacy_id"
      t.index ["location_bred_id"], name: "index_horses_on_location_bred_id"
      t.index ["name"], name: "index_horses_on_name"
      t.index ["owner_id"], name: "index_horses_on_owner_id"
      t.index ["public_id"], name: "index_horses_on_public_id"
      t.index ["sire_id"], name: "index_horses_on_sire_id"
      t.index ["slug"], name: "index_horses_on_slug"
      t.index ["status"], name: "index_horses_on_status"
    end

    create_table "jockeys" do |t|
      t.integer "acceleration", null: false
      t.integer "average_speed", null: false
      t.integer "break_speed", null: false
      t.integer "closing", null: false
      t.integer "consistency", null: false
      t.integer "courage", null: false
      t.datetime "created_at", null: false
      t.date "date_of_birth", null: false
      t.integer "dirt", null: false
      t.integer "experience", null: false
      t.integer "experience_rate", null: false
      t.integer "fast", null: false
      t.string "first_name", null: false
      t.enum "gender", comment: "male, female", enum_type: "jockey_gender"
      t.integer "good", null: false
      t.integer "height_in_inches", null: false
      t.enum "jockey_type", comment: "flat, jump", enum_type: "jockey_type"
      t.string "last_name", null: false
      t.integer "leading", null: false
      t.integer "legacy_id", null: false
      t.integer "loaf_threshold", null: false
      t.integer "looking", null: false
      t.integer "max_speed", null: false
      t.integer "midpack", null: false
      t.integer "min_speed", null: false
      t.integer "off_pace", null: false
      t.integer "pissy", null: false
      t.string "public_id", limit: 12
      t.integer "rating", null: false
      t.integer "slow", null: false
      t.string "slug"
      t.enum "status", comment: "apprentice, veteran, retired", enum_type: "jockey_status"
      t.integer "steeplechase", null: false
      t.integer "strength", null: false
      t.integer "traffic", null: false
      t.integer "turf", null: false
      t.integer "turning", null: false
      t.datetime "updated_at", null: false
      t.integer "weight", null: false
      t.integer "wet", null: false
      t.integer "whip_seconds", null: false
      t.index "first_name, lower((last_name)::text)", name: "index_jockeys_on_unique_name", unique: true
      t.index ["date_of_birth"], name: "index_jockeys_on_date_of_birth"
      t.index ["first_name", "last_name"], name: "index_jockeys_on_first_name_and_last_name", unique: true
      t.index ["gender"], name: "index_jockeys_on_gender"
      t.index ["height_in_inches"], name: "index_jockeys_on_height_in_inches"
      t.index ["jockey_type"], name: "index_jockeys_on_jockey_type"
      t.index ["last_name"], name: "index_jockeys_on_last_name"
      t.index ["legacy_id"], name: "index_jockeys_on_legacy_id"
      t.index ["public_id"], name: "index_jockeys_on_public_id"
      t.index ["slug"], name: "index_jockeys_on_slug"
      t.index ["status"], name: "index_jockeys_on_status"
      t.index ["weight"], name: "index_jockeys_on_weight"
    end

    create_table "locations" do |t|
      t.string "country", null: false
      t.string "county"
      t.datetime "created_at", null: false
      t.boolean "has_farm", default: true, null: false
      t.string "name", null: false
      t.string "state"
      t.datetime "updated_at", null: false
      t.index ["country", "name"], name: "index_locations_on_country_and_name", unique: true
      t.index ["name"], name: "index_locations_on_name"
    end

    create_table "motor_alert_locks" do |t|
      t.bigint "alert_id", null: false
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.string "lock_timestamp", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["alert_id", "lock_timestamp"], name: "index_motor_alert_locks_on_alert_id_and_lock_timestamp", unique: true
    end

    create_table "motor_alerts" do |t|
      t.bigint "author_id"
      t.string "author_type"
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.datetime "deleted_at", precision: nil
      t.text "description"
      t.boolean "is_enabled", default: true, null: false
      t.string "name", null: false
      t.text "preferences", null: false
      t.bigint "query_id", null: false
      t.text "to_emails", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["author_type", "author_id"], name: "index_motor_alerts_on_author_type_and_author_id", where: "(deleted_at IS NULL)"
      t.index ["name"], name: "motor_alerts_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
      t.index ["query_id"], name: "index_motor_alerts_on_query_id", where: "(deleted_at IS NULL)"
      t.index ["updated_at"], name: "index_motor_alerts_on_updated_at", where: "(deleted_at IS NULL)"
    end

    create_table "motor_api_configs" do |t|
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.text "credentials", null: false
      t.datetime "deleted_at", precision: nil
      t.text "description"
      t.string "name", null: false
      t.text "preferences", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.string "url", null: false
      t.index ["name"], name: "motor_api_configs_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    end

    create_table "motor_audits" do |t|
      t.string "action"
      t.string "associated_id"
      t.string "associated_type"
      t.string "auditable_id"
      t.string "auditable_type"
      t.text "audited_changes"
      t.text "comment"
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.string "remote_address"
      t.string "request_uuid"
      t.datetime "updated_at", precision: nil, null: false
      t.bigint "user_id"
      t.string "user_type"
      t.string "username"
      t.bigint "version", default: 0
      t.index ["associated_type", "associated_id"], name: "motor_auditable_associated_index"
      t.index ["auditable_type", "auditable_id", "version"], name: "motor_auditable_index"
      t.index ["created_at"], name: "index_motor_audits_on_created_at"
      t.index ["request_uuid"], name: "index_motor_audits_on_request_uuid"
      t.index ["user_id", "user_type"], name: "motor_auditable_user_index"
    end

    create_table "motor_configs" do |t|
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.string "key", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.text "value", null: false
      t.index ["key"], name: "index_motor_configs_on_key", unique: true
      t.index ["updated_at"], name: "index_motor_configs_on_updated_at"
    end

    create_table "motor_dashboards" do |t|
      t.bigint "author_id"
      t.string "author_type"
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.datetime "deleted_at", precision: nil
      t.text "description"
      t.text "preferences", null: false
      t.string "title", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["author_type", "author_id"], name: "index_motor_dashboards_on_author_type_and_author_id", where: "(deleted_at IS NULL)"
      t.index ["title"], name: "motor_dashboards_title_unique_index", unique: true, where: "(deleted_at IS NULL)"
      t.index ["updated_at"], name: "index_motor_dashboards_on_updated_at", where: "(deleted_at IS NULL)"
    end

    create_table "motor_forms" do |t|
      t.string "api_config_name", null: false
      t.text "api_path", null: false
      t.bigint "author_id"
      t.string "author_type"
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.datetime "deleted_at", precision: nil
      t.text "description"
      t.string "http_method", null: false
      t.string "name", null: false
      t.text "preferences", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["api_config_name"], name: "index_motor_forms_on_api_config_name", where: "(deleted_at IS NULL)"
      t.index ["author_type", "author_id"], name: "index_motor_forms_on_author_type_and_author_id", where: "(deleted_at IS NULL)"
      t.index ["name"], name: "motor_forms_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
      t.index ["updated_at"], name: "index_motor_forms_on_updated_at", where: "(deleted_at IS NULL)"
    end

    create_table "motor_queries" do |t|
      t.bigint "author_id"
      t.string "author_type"
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.datetime "deleted_at", precision: nil
      t.text "description"
      t.string "name", null: false
      t.text "preferences", null: false
      t.text "sql_body", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["author_type", "author_id"], name: "index_motor_queries_on_author_type_and_author_id", where: "(deleted_at IS NULL)"
      t.index ["name"], name: "motor_queries_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
      t.index ["updated_at"], name: "index_motor_queries_on_updated_at", where: "(deleted_at IS NULL)"
    end

    create_table "motor_resources" do |t|
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.string "name", null: false
      t.text "preferences", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["name"], name: "index_motor_resources_on_name", unique: true
      t.index ["updated_at"], name: "index_motor_resources_on_updated_at"
    end

    create_table "motor_taggable_tags" do |t|
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.bigint "tag_id", null: false
      t.bigint "taggable_id", null: false
      t.string "taggable_type", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["tag_id"], name: "index_motor_taggable_tags_on_tag_id"
      t.index ["taggable_id", "taggable_type", "tag_id"], name: "motor_polymorphic_association_tag_index", unique: true
    end

    create_table "motor_tags" do |t|
      t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
      t.string "name", null: false
      t.datetime "updated_at", precision: nil, null: false
      t.index ["name"], name: "motor_tags_name_unique_index", unique: true
    end

    create_table "race_odds" do |t|
      t.datetime "created_at", null: false
      t.string "display", null: false
      t.datetime "updated_at", null: false
      t.decimal "value", precision: 3, scale: 1, null: false
      t.index ["display"], name: "index_race_odds_on_display"
    end

    create_table "race_records" do |t|
      t.datetime "created_at", null: false
      t.bigint "earnings", default: 0, null: false
      t.integer "fourths", default: 0, null: false
      t.bigint "horse_id", null: false
      t.integer "points", default: 0, null: false
      t.enum "result_type", default: "dirt", comment: "dirt, turf, steeplechase", enum_type: "race_result_types"
      t.integer "seconds", default: 0, null: false
      t.integer "stakes_fourths", default: 0, null: false
      t.integer "stakes_seconds", default: 0, null: false
      t.integer "stakes_starts", default: 0, null: false
      t.integer "stakes_thirds", default: 0, null: false
      t.integer "stakes_wins", default: 0, null: false
      t.integer "starts", default: 0, null: false
      t.integer "thirds", default: 0, null: false
      t.datetime "updated_at", null: false
      t.integer "wins", default: 0, null: false
      t.integer "year", default: 1996, null: false
      t.index ["horse_id", "year", "result_type"], name: "index_race_records_on_horse_id_and_year_and_result_type", unique: true
      t.index ["result_type"], name: "index_race_records_on_result_type"
      t.index ["stakes_starts"], name: "index_race_records_on_stakes_starts"
      t.index ["stakes_wins"], name: "index_race_records_on_stakes_wins"
      t.index ["starts"], name: "index_race_records_on_starts"
      t.index ["wins"], name: "index_race_records_on_wins"
      t.index ["year"], name: "index_race_records_on_year"
    end

    create_table "race_result_horses" do |t|
      t.datetime "created_at", null: false
      t.integer "equipment", default: 0, null: false
      t.integer "finish_position", default: 1, null: false
      t.string "fractions"
      t.bigint "horse_id", null: false
      t.bigint "jockey_id"
      t.integer "legacy_horse_id", default: 0, null: false
      t.string "margins", null: false
      t.bigint "odd_id"
      t.string "positions", null: false
      t.integer "post_parade", default: 1, null: false
      t.bigint "race_id", null: false
      t.integer "speed_factor", default: 0, null: false
      t.datetime "updated_at", null: false
      t.integer "weight", default: 0, null: false
      t.index ["finish_position"], name: "index_race_result_horses_on_finish_position"
      t.index ["horse_id"], name: "index_race_result_horses_on_horse_id"
      t.index ["jockey_id"], name: "index_race_result_horses_on_jockey_id"
      t.index ["legacy_horse_id"], name: "index_race_result_horses_on_legacy_horse_id"
      t.index ["odd_id"], name: "index_race_result_horses_on_odd_id"
      t.index ["race_id"], name: "index_race_result_horses_on_race_id"
      t.index ["speed_factor"], name: "index_race_result_horses_on_speed_factor"
    end

    create_table "race_results" do |t|
      t.enum "age", default: "2", null: false, comment: "2, 2+, 3, 3+, 4, 4+", enum_type: "race_age"
      t.integer "claiming_price"
      t.enum "condition", comment: "fast, good, slow, wet", enum_type: "track_condition"
      t.datetime "created_at", null: false
      t.date "date", null: false
      t.decimal "distance", precision: 3, scale: 1, default: "5.0", null: false
      t.boolean "female_only", default: false, null: false
      t.enum "grade", comment: "Ungraded, Grade 3, Grade 2, Grade 1", enum_type: "race_grade"
      t.boolean "male_only", default: false, null: false
      t.string "name"
      t.integer "number", default: 1, null: false
      t.bigint "purse", default: 0, null: false
      t.enum "race_type", default: "maiden", null: false, comment: "maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes", enum_type: "race_type"
      t.string "slug"
      t.enum "split", comment: "4Q, 2F", enum_type: "race_splits"
      t.bigint "surface_id", null: false
      t.decimal "time_in_seconds", precision: 7, scale: 3, default: "0.0", null: false
      t.datetime "updated_at", null: false
      t.index ["age"], name: "index_race_results_on_age"
      t.index ["condition"], name: "index_race_results_on_condition"
      t.index ["date"], name: "index_race_results_on_date"
      t.index ["distance"], name: "index_race_results_on_distance"
      t.index ["grade"], name: "index_race_results_on_grade"
      t.index ["name"], name: "index_race_results_on_name"
      t.index ["number"], name: "index_race_results_on_number"
      t.index ["purse"], name: "index_race_results_on_purse"
      t.index ["race_type"], name: "index_race_results_on_race_type"
      t.index ["slug"], name: "index_race_results_on_slug"
      t.index ["surface_id"], name: "index_race_results_on_surface_id"
      t.index ["time_in_seconds"], name: "index_race_results_on_time_in_seconds"
    end

    create_table "race_schedules" do |t|
      t.enum "age", default: "2", null: false, comment: "2, 2+, 3, 3+, 4, 4+", enum_type: "race_age"
      t.integer "claiming_price"
      t.datetime "created_at", null: false
      t.date "date", null: false
      t.integer "day_number", default: 1, null: false
      t.decimal "distance", precision: 3, scale: 1, default: "5.0", null: false
      t.boolean "female_only", default: false, null: false
      t.enum "grade", comment: "Ungraded, Grade 3, Grade 2, Grade 1", enum_type: "race_grade"
      t.boolean "male_only", default: false, null: false
      t.string "name"
      t.integer "number", default: 1, null: false
      t.bigint "purse", default: 0, null: false
      t.boolean "qualification_required", default: false, null: false
      t.enum "race_type", default: "maiden", null: false, comment: "maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes", enum_type: "race_type"
      t.bigint "surface_id", null: false
      t.datetime "updated_at", null: false
      t.index ["age"], name: "index_race_schedules_on_age"
      t.index ["date"], name: "index_race_schedules_on_date"
      t.index ["day_number"], name: "index_race_schedules_on_day_number"
      t.index ["distance"], name: "index_race_schedules_on_distance"
      t.index ["female_only"], name: "index_race_schedules_on_female_only"
      t.index ["grade"], name: "index_race_schedules_on_grade"
      t.index ["male_only"], name: "index_race_schedules_on_male_only"
      t.index ["name"], name: "index_race_schedules_on_name"
      t.index ["number"], name: "index_race_schedules_on_number"
      t.index ["qualification_required"], name: "index_race_schedules_on_qualification_required"
      t.index ["race_type"], name: "index_race_schedules_on_race_type"
      t.index ["surface_id"], name: "index_race_schedules_on_surface_id"
    end

    create_table "racetracks" do |t|
      t.datetime "created_at", null: false
      t.decimal "latitude", null: false
      t.bigint "location_id", null: false
      t.decimal "longitude", null: false
      t.string "name", null: false
      t.string "public_id", limit: 12
      t.string "slug"
      t.datetime "updated_at", null: false
      t.index "lower((name)::text)", name: "index_racetracks_on_name", unique: true
      t.index ["location_id"], name: "index_racetracks_on_location_id", unique: true
      t.index ["public_id"], name: "index_racetracks_on_public_id"
      t.index ["slug"], name: "index_racetracks_on_slug"
    end

    create_table "sessions" do |t|
      t.datetime "created_at", null: false
      t.text "data"
      t.string "session_id", null: false
      t.datetime "updated_at", null: false
      t.integer "user_id"
      t.index ["session_id"], name: "index_sessions_on_session_id"
      t.index ["user_id"], name: "index_sessions_on_user_id"
    end

    create_table "settings" do |t|
      t.datetime "created_at", null: false
      t.string "locale"
      t.string "theme"
      t.datetime "updated_at", null: false
      t.bigint "user_id", null: false
      t.index ["user_id"], name: "index_settings_on_user_id", unique: true
    end

    create_table "stables" do |t|
      t.bigint "available_balance", default: 0
      t.datetime "created_at", null: false
      t.text "description"
      t.datetime "last_online_at", precision: nil
      t.integer "legacy_id"
      t.integer "miles_from_track", default: 1, null: false
      t.string "name", null: false
      t.string "public_id", limit: 12
      t.bigint "racetrack_id"
      t.string "slug"
      t.bigint "total_balance", default: 0
      t.datetime "updated_at", null: false
      t.bigint "user_id", null: false
      t.index "lower((name)::text)", name: "index_stables_on_name", unique: true
      t.index ["available_balance"], name: "index_stables_on_available_balance"
      t.index ["last_online_at"], name: "index_stables_on_last_online_at"
      t.index ["legacy_id"], name: "index_stables_on_legacy_id"
      t.index ["public_id"], name: "index_stables_on_public_id"
      t.index ["racetrack_id"], name: "index_stables_on_racetrack_id"
      t.index ["slug"], name: "index_stables_on_slug"
      t.index ["total_balance"], name: "index_stables_on_total_balance"
      t.index ["user_id"], name: "index_stables_on_user_id", unique: true
    end

    create_table "track_surfaces" do |t|
      t.integer "banking", null: false
      t.enum "condition", default: "fast", null: false, comment: "fast, good, slow, wet", enum_type: "track_condition"
      t.datetime "created_at", null: false
      t.integer "jumps", default: 0, null: false
      t.integer "length", null: false
      t.bigint "racetrack_id", null: false
      t.enum "surface", default: "dirt", null: false, comment: "dirt, turf, steeplechase", enum_type: "track_surface"
      t.integer "turn_distance", null: false
      t.integer "turn_to_finish_length", null: false
      t.datetime "updated_at", null: false
      t.integer "width", null: false
      t.index ["racetrack_id", "surface"], name: "index_track_surfaces_on_racetrack_id_and_surface", unique: true
    end

    create_table "training_schedules" do |t|
      t.datetime "created_at", null: false
      t.text "description"
      t.jsonb "friday_activities", default: {}, null: false
      t.integer "horses_count", default: 0, null: false
      t.jsonb "monday_activities", default: {}, null: false
      t.string "name", null: false
      t.jsonb "saturday_activities", default: {}, null: false
      t.bigint "stable_id", null: false
      t.jsonb "sunday_activities", default: {}, null: false
      t.jsonb "thursday_activities", default: {}, null: false
      t.jsonb "tuesday_activities", default: {}, null: false
      t.datetime "updated_at", null: false
      t.jsonb "wednesday_activities", default: {}, null: false
      t.index "stable_id, lower((name)::text)", name: "index_training_schedules_on_lowercase_name", unique: true
      t.index ["friday_activities"], name: "index_training_schedules_on_friday_activities", using: :gin
      t.index ["monday_activities"], name: "index_training_schedules_on_monday_activities", using: :gin
      t.index ["saturday_activities"], name: "index_training_schedules_on_saturday_activities", using: :gin
      t.index ["stable_id"], name: "index_training_schedules_on_stable_id"
      t.index ["sunday_activities"], name: "index_training_schedules_on_sunday_activities", using: :gin
      t.index ["thursday_activities"], name: "index_training_schedules_on_thursday_activities", using: :gin
      t.index ["tuesday_activities"], name: "index_training_schedules_on_tuesday_activities", using: :gin
      t.index ["wednesday_activities"], name: "index_training_schedules_on_wednesday_activities", using: :gin
    end

    create_table "training_schedules_horses" do |t|
      t.datetime "created_at", null: false
      t.bigint "horse_id", null: false
      t.bigint "training_schedule_id", null: false
      t.datetime "updated_at", null: false
      t.index ["horse_id"], name: "index_training_schedules_horses_on_horse_id", unique: true
      t.index ["training_schedule_id"], name: "index_training_schedules_horses_on_training_schedule_id"
    end

    create_table "user_push_subscriptions" do |t|
      t.string "auth_key"
      t.datetime "created_at", null: false
      t.string "endpoint"
      t.string "p256dh_key"
      t.datetime "updated_at", null: false
      t.string "user_agent"
      t.bigint "user_id", null: false
      t.index ["user_id"], name: "index_user_push_subscriptions_on_user_id"
    end

    create_table "users" do |t|
      t.boolean "admin", default: false, null: false
      t.datetime "confirmation_sent_at", precision: nil
      t.string "confirmation_token"
      t.datetime "confirmed_at", precision: nil
      t.datetime "created_at", null: false
      t.datetime "current_sign_in_at", precision: nil
      t.string "current_sign_in_ip"
      t.boolean "developer", default: false, null: false
      t.datetime "discarded_at", precision: nil
      t.integer "discourse_id"
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.integer "failed_attempts", default: 0, null: false
      t.datetime "last_sign_in_at", precision: nil
      t.string "last_sign_in_ip"
      t.datetime "locked_at", precision: nil
      t.string "name", null: false
      t.string "public_id", limit: 12
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
      t.index ["admin"], name: "index_users_on_admin", where: "(discarded_at IS NOT NULL)"
      t.index ["developer"], name: "index_users_on_developer", where: "(discarded_at IS NOT NULL)"
      t.index ["discourse_id"], name: "index_users_on_discourse_id", unique: true, where: "(discarded_at IS NOT NULL)"
      t.index ["email"], name: "index_users_on_email", unique: true, where: "(discarded_at IS NOT NULL)"
      t.index ["name"], name: "index_users_on_name", where: "(discarded_at IS NOT NULL)"
      t.index ["public_id"], name: "index_users_on_public_id", unique: true, where: "(discarded_at IS NOT NULL)"
      t.index ["slug"], name: "index_users_on_slug", unique: true, where: "(discarded_at IS NOT NULL)"
      t.index ["username"], name: "index_users_on_username", unique: true, where: "(discarded_at IS NOT NULL)"
    end

    add_foreign_key "activations", "users", on_update: :cascade, on_delete: :cascade
    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
    add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
    add_foreign_key "activity_points", "budget_transactions", column: "budget_id", on_update: :cascade, on_delete: :nullify
    add_foreign_key "activity_points", "stables", on_update: :cascade, on_delete: :cascade
    add_foreign_key "auction_bids", "auction_horses", column: "horse_id", on_update: :cascade, on_delete: :cascade
    add_foreign_key "auction_bids", "auctions", on_update: :cascade, on_delete: :cascade
    add_foreign_key "auction_bids", "stables", column: "bidder_id", on_update: :cascade, on_delete: :cascade
    add_foreign_key "auction_consignment_configs", "auctions", on_update: :cascade, on_delete: :cascade
    add_foreign_key "auction_horses", "auctions", on_update: :cascade, on_delete: :cascade
    add_foreign_key "auction_horses", "horses", on_update: :cascade, on_delete: :cascade
    add_foreign_key "auctions", "stables", column: "auctioneer_id", on_update: :cascade, on_delete: :cascade
    add_foreign_key "boardings", "horses"
    add_foreign_key "boardings", "locations"
    add_foreign_key "broodmare_foal_records", "horses", on_update: :cascade, on_delete: :cascade
    add_foreign_key "budget_transactions", "stables", on_update: :cascade, on_delete: :cascade
    add_foreign_key "horse_appearances", "horses", on_update: :cascade, on_delete: :cascade
    add_foreign_key "horse_attributes", "horses", on_update: :cascade, on_delete: :cascade
    add_foreign_key "horse_genetics", "horses", on_update: :cascade, on_delete: :cascade
    add_foreign_key "horses", "horses", column: "dam_id", on_update: :cascade, on_delete: :nullify, validate: false
    add_foreign_key "horses", "horses", column: "sire_id", on_update: :cascade, on_delete: :nullify
    add_foreign_key "horses", "locations", column: "location_bred_id", on_update: :cascade, on_delete: :restrict
    add_foreign_key "horses", "stables", column: "breeder_id", on_update: :cascade, on_delete: :restrict, validate: false
    add_foreign_key "horses", "stables", column: "owner_id", on_update: :cascade, on_delete: :restrict
    add_foreign_key "motor_alert_locks", "motor_alerts", column: "alert_id"
    add_foreign_key "motor_alerts", "motor_queries", column: "query_id"
    add_foreign_key "motor_taggable_tags", "motor_tags", column: "tag_id"
    add_foreign_key "race_records", "horses", on_update: :cascade, on_delete: :cascade
    add_foreign_key "race_result_horses", "horses", on_update: :cascade, on_delete: :restrict
    add_foreign_key "race_result_horses", "jockeys", on_update: :cascade, on_delete: :restrict
    add_foreign_key "race_result_horses", "race_results", column: "odd_id", on_update: :cascade, on_delete: :nullify, validate: false
    add_foreign_key "race_result_horses", "race_results", column: "race_id", on_update: :cascade, on_delete: :cascade
    add_foreign_key "race_results", "track_surfaces", column: "surface_id", on_update: :cascade, on_delete: :restrict
    add_foreign_key "race_schedules", "track_surfaces", column: "surface_id", on_update: :cascade, on_delete: :restrict
    add_foreign_key "racetracks", "locations", on_update: :cascade, on_delete: :restrict
    add_foreign_key "settings", "users", on_update: :cascade, on_delete: :cascade
    add_foreign_key "stables", "racetracks", on_update: :cascade, on_delete: :nullify
    add_foreign_key "stables", "users", on_update: :cascade, on_delete: :restrict
    add_foreign_key "track_surfaces", "racetracks", on_update: :cascade, on_delete: :cascade
    add_foreign_key "training_schedules", "stables", on_update: :cascade, on_delete: :cascade, validate: false
    add_foreign_key "training_schedules_horses", "horses", on_update: :cascade, on_delete: :cascade
    add_foreign_key "training_schedules_horses", "training_schedules", on_update: :cascade, on_delete: :cascade, validate: false
    add_foreign_key "user_push_subscriptions", "users", on_update: :cascade, on_delete: :cascade

    create_view "annual_race_records", materialized: true, sql_definition: <<-SQL.squish
      SELECT year,
      horse_id,
      sum(starts) AS starts,
      sum(stakes_starts) AS stakes_starts,
      sum(wins) AS wins,
      sum(stakes_wins) AS stakes_wins,
      sum(seconds) AS seconds,
      sum(stakes_seconds) AS stakes_seconds,
      sum(thirds) AS thirds,
      sum(stakes_thirds) AS stakes_thirds,
      sum(fourths) AS fourths,
      sum(stakes_fourths) AS stakes_fourths,
      sum(points) AS points,
      sum(earnings) AS earnings
     FROM race_records
    GROUP BY year, horse_id;
    SQL
    create_view "lifetime_race_records", materialized: true, sql_definition: <<-SQL.squish
      SELECT horse_id,
      sum(starts) AS starts,
      sum(stakes_starts) AS stakes_starts,
      sum(wins) AS wins,
      sum(stakes_wins) AS stakes_wins,
      sum(seconds) AS seconds,
      sum(stakes_seconds) AS stakes_seconds,
      sum(thirds) AS thirds,
      sum(stakes_thirds) AS stakes_thirds,
      sum(fourths) AS fourths,
      sum(stakes_fourths) AS stakes_fourths,
      sum(points) AS points,
      sum(earnings) AS earnings
     FROM race_records
    GROUP BY horse_id;
    SQL
    add_index "lifetime_race_records", ["horse_id"], name: "index_lifetime_race_records_on_horse_id", unique: true
  end
end

