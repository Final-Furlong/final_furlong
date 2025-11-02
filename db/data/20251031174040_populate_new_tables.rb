class PopulateNewTables < ActiveRecord::Migration[8.1]
  def up
    statements = [
      "INSERT INTO new_activations (activated_at, token, old_user_id, created_at, updated_at)
      SELECT activated_at, token, user_id, created_at, updated_at FROM activations;",
      "INSERT INTO new_activity_points
        (activity_type, amount, balance, old_budget_id, legacy_stable_id, old_stable_id, created_at, updated_at, old_id)
      SELECT activity_type, amount, balance, budget_id, legacy_stable_id, stable_id, created_at, updated_at, id FROM activity_points;",
      "INSERT INTO new_auction_bids
        (old_auction_id, old_bidder_id, comment, current_bid, notify_if_outbid, old_horse_id, maximum_bid, old_id, created_at, updated_at)
      SELECT auction_id, bidder_id, comment, current_bid, email_if_outbid, horse_id, maximum_bid, id, created_at, updated_at FROM auction_bids;",
      "INSERT INTO new_auction_consignment_configs
        (old_auction_id, horse_type, maximum_age, minimum_age, minimum_count, stakes_quality, created_at, updated_at, old_id)
      SELECT auction_id, horse_type, maximum_age, minimum_age, minimum_count, stakes_quality, created_at, updated_at, id FROM auction_consignment_configs;",
      "INSERT INTO new_auction_horses
        (old_auction_id, comment, old_horse_id, maximum_price, reserve_price, sold_at, old_id, created_at, updated_at)
      SELECT auction_id, comment, horse_id, maximum_price, reserve_price, sold_at, id, created_at, updated_at FROM auction_horses;",
      "INSERT INTO new_auctions
        (old_auctioneer_id, broodmare_allowed, end_time, horse_purchase_cap_per_stable, hours_until_sold,
         outside_horses_allowed, racehorse_allowed_2yo, racehorse_allowed_3yo, racehorse_allowed_older,
         reserve_pricing_allowed, spending_cap_per_stable, stallion_allowed, start_time, title,
         weanling_allowed, yearling_allowed, old_id, created_at, updated_at)
      SELECT auctioneer_id, broodmare_allowed, end_time, horse_purchase_cap_per_stable, hours_until_sold,
         outside_horses_allowed, racehorse_allowed_2yo, racehorse_allowed_3yo, racehorse_allowed_older,
         reserve_pricing_allowed, spending_cap_per_stable, stallion_allowed, start_time, title,
         weanling_allowed, yearling_allowed, id, created_at, updated_at FROM auctions;",
      "INSERT INTO new_broodmare_foal_records
        (born_foals_count, breed_ranking, old_horse_id, millionaire_foals_count,
         multi_millionaire_foals_count, multi_stakes_winning_foals_count, raced_foals_count,
         stakes_winning_foals_count, stillborn_foals_count, total_foal_earnings,
         total_foal_points, total_foal_races, unborn_foals_count, winning_foals_count,
         created_at, updated_at, old_id)
      SELECT born_foals_count, breed_ranking, horse_id, millionaire_foals_count,
         multi_millionaire_foals_count, multi_stakes_winning_foals_count, raced_foals_count,
         stakes_winning_foals_count, stillborn_foals_count, total_foal_earnings,
         total_foal_points, total_foal_races, unborn_foals_count, winning_foals_count,
         created_at, updated_at, id FROM broodmare_foal_records;",
      "INSERT INTO new_budget_transactions
        (amount, balance, description, legacy_budget_id, legacy_stable_id, old_stable_id, old_id, created_at, updated_at)
      SELECT amount, balance, description, legacy_budget_id, legacy_stable_id, stable_id, id, created_at, updated_at FROM budgets;",
      "INSERT INTO new_game_activity_points
        (activity_type, first_year_points, older_year_points, second_year_points, created_at, updated_at, old_id)
      SELECT activity_type, first_year_points, older_year_points, second_year_points, created_at, updated_at, id FROM game_activity_points;",
      "INSERT INTO new_game_alerts
        (display_to_newbies, display_to_non_newbies, end_time, message, start_time, created_at, updated_at, old_id)
      SELECT display_to_newbies, display_to_non_newbies, end_time, message, start_time, created_at, updated_at, id FROM game_alerts;",
      "INSERT INTO new_horse_appearances
        (birth_height, color, current_height, face_image, face_marking, old_horse_id, lf_leg_image,
         lf_leg_marking, lh_leg_image, lh_leg_marking, max_height, rf_leg_image, rf_leg_marking,
         rh_leg_image, rh_leg_marking, old_id, created_at, updated_at)
      SELECT birth_height, color, current_height, face_image, face_marking, horse_id, lf_leg_image,
         lf_leg_marking, lh_leg_image, lh_leg_marking, max_height, rf_leg_image, rf_leg_marking,
         rh_leg_image, rh_leg_marking, id, created_at, updated_at FROM horse_appearances;",
      "INSERT INTO new_horse_attributes
        (breeding_record, dosage_text, old_horse_id, title, track_record, old_id, created_at, updated_at)
      SELECT lower(breeding_record)::breed_record, dosage_text, horse_id, title, track_record, id, created_at, updated_at FROM horse_attributes;",
      "INSERT INTO new_horse_genetics
        (allele, old_horse_id, old_id, created_at, updated_at)
      SELECT allele, horse_id, id, created_at, updated_at FROM horse_genetics;",
      "INSERT INTO new_horses
        (age, old_breeder_id, old_dam_id, date_of_birth, date_of_death, gender, legacy_id,
         old_location_bred_id, name, old_owner_id, old_sire_id, slug, status, old_id, created_at, updated_at)
      SELECT age, breeder_id, dam_id, date_of_birth, date_of_death, gender, legacy_id,
         location_bred_id, name, owner_id, sire_id, slug, status, id, created_at, updated_at FROM horses;",
      "INSERT INTO new_jockeys
        (acceleration, average_speed, break_speed, closing, consistency, courage, date_of_birth,
         dirt, experience, experience_rate, fast, first_name, gender, good, height_in_inches,
         jockey_type, last_name, \"leading\", legacy_id, loaf_threshold, looking, max_speed,
         midpack, min_speed, off_pace, pissy, rating, slow, status, steeplechase, strength,
         traffic, turf, turning, weight, wet, whip_seconds, old_id, created_at, updated_at)
      SELECT acceleration, average_speed, break_speed, closing, consistency, courage, date_of_birth,
         dirt, experience, experience_rate, fast, first_name, gender, good, height_in_inches,
         jockey_type, last_name, \"leading\", legacy_id, loaf_threshold, looking, max_speed,
         midpack, min_speed, off_pace, pissy, rating, slow, status, steeplechase, strength,
         traffic, turf, turning, weight, wet, whip_seconds, id, created_at, updated_at FROM jockeys;",
      "INSERT INTO new_locations
        (country, county, name, state, old_id, created_at, updated_at)
      SELECT country, county, name, state, id, created_at, updated_at FROM locations;",
      "INSERT INTO new_race_odds (display, value, old_id, created_at, updated_at)
      SELECT display, value, id, created_at, updated_at FROM race_odds;",
      "INSERT INTO new_race_records
        (earnings, fourths, old_horse_id, points, result_type, seconds, stakes_fourths,
        stakes_seconds, stakes_starts, stakes_thirds, stakes_wins, starts, thirds,
        wins, year, created_at, updated_at, old_id)
      SELECT earnings, fourths, horse_id, points, result_type, seconds, stakes_fourths,
        stakes_seconds, stakes_starts, stakes_thirds, stakes_wins, starts, thirds,
        wins, year, created_at, updated_at, id FROM race_records;",
      "INSERT INTO new_race_result_horses
        (equipment, finish_position, fractions, old_horse_id, old_jockey_id, legacy_horse_id,
         margins, old_odd_id, positions, post_parade, old_race_id, speed_factor, weight, created_at, updated_at, old_id)
      SELECT equipment, finish_position, fractions, horse_id, jockey_id, legacy_horse_id,
         margins, odd_id, positions, post_parade, race_id, speed_factor, weight, created_at, updated_at, id FROM race_result_horses;",
      "INSERT INTO new_race_results
        (age, claiming_price, condition, date, distance, female_only, grade, male_only, name, number,
         purse, race_type, split, old_surface_id, time_in_seconds, created_at, updated_at, old_id)
      SELECT age, claiming_price, condition, date, distance, female_only, grade, male_only, name, number,
         purse, race_type, split, surface_id, time_in_seconds, created_at, updated_at, id FROM race_results;",
      "INSERT INTO new_race_schedules
        (age, claiming_price, date, day_number, distance, female_only, grade, male_only, name,
         number, purse, qualification_required, race_type, old_surface_id, created_at, updated_at, old_id)
      SELECT age, claiming_price, date, day_number, distance, female_only, grade, male_only, name,
         number, purse, qualification_required, race_type, surface_id, created_at, updated_at, id FROM race_schedules;",
      "INSERT INTO new_racetracks
        (latitude, old_location_id, longitude, name, created_at, updated_at, old_id)
      SELECT latitude, location_id, longitude, name, created_at, updated_at, id FROM racetracks;",
      "INSERT INTO new_settings (locale, theme, old_user_id, created_at, updated_at, old_id)
      SELECT locale, theme, CAST(user_id AS uuid), created_at, updated_at, id FROM settings;",
      "INSERT INTO new_stables
        (available_balance, description, last_online_at, legacy_id, miles_from_track, name,
         old_racetrack_id, total_balance, old_user_id, created_at, updated_at, old_id)
      SELECT available_balance, description, last_online_at, legacy_id, miles_from_track, name,
         racetrack_id, total_balance, user_id, created_at, updated_at, id FROM stables;",
      "INSERT INTO new_track_surfaces
        (banking, condition, jumps, length, old_racetrack_id, surface, turn_distance,
         turn_to_finish_length, width, created_at, updated_at, old_id)
      SELECT banking, condition, jumps, length, racetrack_id, surface, turn_distance,
         turn_to_finish_length, width, created_at, updated_at, id FROM track_surfaces;",
      "INSERT INTO new_training_schedules
        (description, friday_activities, horses_count, monday_activities, name, saturday_activities,
         old_stable_id, sunday_activities, thursday_activities, tuesday_activities,
         wednesday_activities, created_at, updated_at, old_id)
      SELECT description, friday_activities, horses_count, monday_activities, name, saturday_activities,
         stable_id, sunday_activities, thursday_activities, tuesday_activities,
         wednesday_activities, created_at, updated_at, id FROM training_schedules;",
      "INSERT INTO new_training_schedules_horses
        (old_horse_id, old_training_schedule_id, created_at, updated_at)
      SELECT horse_id, training_schedule_id, created_at, updated_at FROM training_schedules_horses;",
      "INSERT INTO new_user_push_subscriptions
        (auth_key, endpoint, p256dh_key, user_agent, old_user_id, created_at, updated_at, old_id)
      SELECT auth_key, endpoint, p256dh_key, user_agent, user_id, created_at, updated_at, id FROM user_push_subscriptions;",
      "INSERT INTO new_users
        (admin, confirmation_sent_at, confirmation_token, confirmed_at, current_sign_in_at,
         current_sign_in_ip, developer, discarded_at, discourse_id, email, encrypted_password,
         failed_attempts, last_sign_in_at, last_sign_in_ip, locked_at, name, remember_created_at,
         reset_password_sent_at, reset_password_token, sign_in_count, status, unconfirmed_email,
         unlock_token, username, created_at, updated_at, old_id)
      SELECT admin, confirmation_sent_at, confirmation_token, confirmed_at, current_sign_in_at,
         current_sign_in_ip, developer, discarded_at, discourse_id, email, encrypted_password,
         failed_attempts, last_sign_in_at, last_sign_in_ip, locked_at, name, remember_created_at,
         reset_password_sent_at, reset_password_token, sign_in_count, status, unconfirmed_email,
         unlock_token, username, created_at, updated_at, id FROM users;"
    ]
    ActiveRecord::Base.transaction do
      statements.each do |sql|
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end

  def down
    tables = %w[
      new_activations
      new_activity_points
      new_auction_bids
      new_auction_consignment_configs
      new_auction_horses
      new_auctions
      new_broodmare_foal_records
      new_budget_transactions
      new_game_activity_points
      new_game_alerts
      new_horse_appearances
      new_horse_attributes
      new_horse_genetics
      new_horses
      new_jockeys
      new_locations
      new_race_odds
      new_race_records
      new_race_result_horses
      new_race_results
      new_race_schedules
      new_racetracks
      new_sessions
      new_settings
      new_stables
      new_track_surfaces
      new_training_schedules
      new_training_schedules_horses
      new_user_push_subscriptions
      new_users
    ]
    ActiveRecord::Base.transaction do
      tables.each do |table|
        ActiveRecord::Base.connection.execute("DELETE FROM #{table};")
      end
    end
  end
end

