class RenameNewTablesAndBackupOldOnes < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      ###### OLD TABLES
      rename_index :activations, :index_activations_on_user_id, :index_bk_activations_on_user_id
      rename_table :activations, :backup_activations

      rename_index :activity_points, :index_activity_points_on_activity_type, :index_bk_activity_points_on_activity_type
      rename_index :activity_points, :index_activity_points_on_budget_id, :index_bk_activity_points_on_budget_id
      rename_index :activity_points, :index_activity_points_on_legacy_stable_id, :index_bk_activity_points_on_legacy_stable_id
      rename_index :activity_points, :index_activity_points_on_stable_id, :index_bk_activity_points_on_stable_id
      rename_table :activity_points, :backup_activity_points

      rename_index :auction_bids, :index_auction_bids_on_auction_id, :index_bk_auction_bids_on_auction_id
      rename_index :auction_bids, :index_auction_bids_on_bidder_id, :index_bk_auction_bids_on_bidder_id
      rename_index :auction_bids, :index_auction_bids_on_horse_id, :index_bk_auction_bids_on_horse_id
      rename_table :auction_bids, :backup_auction_bids

      rename_index :auction_consignment_configs, :index_auction_consignment_configs_on_auction_id, :index_bk_auction_consignment_configs_on_auction_id
      rename_index :auction_consignment_configs, :index_consignment_configs_on_horse_type, :index_bk_consignment_configs_on_horse_type
      rename_table :auction_consignment_configs, :backup_auction_consignment_configs

      rename_index :auction_horses, :index_auction_horses_on_auction_id, :index_bk_auction_horses_on_auction_id
      rename_index :auction_horses, :index_auction_horses_on_horse_id, :index_bk_auction_horses_on_horse_id
      rename_index :auction_horses, :index_auction_horses_on_sold_at, :index_bk_auction_horses_on_sold_at
      rename_table :auction_horses, :backup_auction_horses

      rename_index :auctions, :index_auctions_on_auctioneer_id, :index_bk_auctions_on_auctioneer_id
      rename_index :auctions, :index_auctions_on_end_time, :index_bk_auctions_on_end_time
      rename_index :auctions, :index_auctions_on_start_time, :index_bk_auctions_on_start_time
      rename_index :auctions, :index_auctions_on_title, :index_bk_auctions_on_title
      rename_table :auctions, :backup_auctions

      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_born_foals_count, :index_bk_bm_foal_records_on_born_foals_count
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_unborn_foals_count, :index_bk_bm_foal_records_on_unborn_foals_count
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_raced_foals_count, :index_bk_bm_foal_records_on_raced_foals_count
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_winning_foals_count, :index_bk_bm_foal_records_on_winning_foals_count
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_stakes_winning_foals_count, :index_bk_bm_foal_records_on_stakes_winning_foals_count
      rename_index :broodmare_foal_records, :idx_on_multi_stakes_winning_foals_count_d86a3500a8, :idx_bk_on_multi_stakes_winning_foals_count_d86a3500a8
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_millionaire_foals_count, :index_bk_bm_foal_records_on_millionaire_foals_count
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_multi_millionaire_foals_count, :index_bk_bm_foal_records_on_multi_millionaire_foals_count
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_breed_ranking, :index_bk_bm_foal_records_on_breed_ranking
      rename_index :broodmare_foal_records, :index_broodmare_foal_records_on_horse_id, :index_bk_bm_foal_records_on_horse_id
      rename_table :broodmare_foal_records, :backup_broodmare_foal_records

      rename_table :budgets, :backup_budgets

      rename_index :game_activity_points, :index_game_activity_points_on_activity_type, :index_bk_game_activity_points_on_activity_type
      rename_table :game_activity_points, :backup_game_activity_points

      rename_index :game_alerts, :index_game_alerts_on_end_time, :index_bk_game_alerts_on_end_time
      rename_index :game_alerts, :index_game_alerts_on_start_time, :index_bk_game_alerts_on_start_time
      rename_table :game_alerts, :backup_game_alerts

      rename_index :horse_appearances, :index_horse_appearances_on_horse_id, :index_bk_horse_appearances_on_horse_id
      rename_table :horse_appearances, :backup_horse_appearances

      rename_index :horse_attributes, :index_horse_attributes_on_horse_id, :index_bk_horse_attributes_on_horse_id
      rename_table :horse_attributes, :backup_horse_attributes

      rename_index :horse_genetics, :index_horse_genetics_on_horse_id, :index_bk_horse_genetics_on_horse_id
      rename_table :horse_genetics, :backup_horse_genetics

      rename_index :horses, :index_horses_on_breeder_id, :index_bk_horses_on_breeder_id
      rename_index :horses, :index_horses_on_owner_id, :index_bk_horses_on_owner_id
      rename_index :horses, :index_horses_on_created_at, :index_bk_horses_on_created_at
      rename_index :horses, :index_horses_on_dam_id, :index_bk_horses_on_dam_id
      rename_index :horses, :index_horses_on_date_of_birth, :index_bk_horses_on_date_of_birth
      rename_index :horses, :index_horses_on_legacy_id, :index_bk_horses_on_legacy_id
      rename_index :horses, :index_horses_on_location_bred_id, :index_bk_horses_on_location_bred_id
      rename_index :horses, :index_horses_on_name, :index_bk_horses_on_name
      rename_index :horses, :index_horses_on_sire_id, :index_bk_horses_on_sire_id
      rename_index :horses, :index_horses_on_status, :index_bk_horses_on_status
      rename_index :horses, :index_horses_on_slug, :index_bk_horses_on_slug
      rename_table :horses, :backup_horses

      rename_index :jockeys, :index_jockeys_on_gender, :index_bk_jockeys_on_gender
      rename_index :jockeys, :index_jockeys_on_height_in_inches, :index_bk_jockeys_on_height_in_inches
      rename_index :jockeys, :index_jockeys_on_jockey_type, :index_bk_jockeys_on_jockey_type
      rename_index :jockeys, :index_jockeys_on_legacy_id, :index_bk_jockeys_on_legacy_id
      rename_index :jockeys, :index_jockeys_on_status, :index_bk_jockeys_on_status
      rename_index :jockeys, :index_jockeys_on_weight, :index_bk_jockeys_on_weight
      rename_table :jockeys, :backup_jockeys

      rename_index :locations, :index_locations_on_country_and_name, :index_bk_locations_on_country_and_name
      rename_table :locations, :backup_locations

      rename_table :race_odds, :backup_race_odds

      rename_index :race_records, :index_race_records_on_horse_id_and_year_and_result_type, :index_bk_rrs_on_horse_id_and_year_and_result_type
      rename_index :race_records, :index_race_records_on_result_type, :index_bk_race_records_on_result_type
      rename_index :race_records, :index_race_records_on_year, :index_bk_race_records_on_year
      rename_table :race_records, :backup_race_records

      rename_index :race_result_horses, :index_race_result_horses_on_finish_position, :index_bk_rr_horses_on_finish_position
      rename_index :race_result_horses, :index_race_result_horses_on_horse_id, :index_bk_race_result_horses_on_horse_id
      rename_index :race_result_horses, :index_race_result_horses_on_jockey_id, :index_bk_race_result_horses_on_jockey_id
      rename_index :race_result_horses, :index_race_result_horses_on_legacy_horse_id, :index_bk_race_result_horses_on_legacy_horse_id
      rename_index :race_result_horses, :index_race_result_horses_on_odd_id, :index_bk_race_result_horses_on_odd_id
      rename_index :race_result_horses, :index_race_result_horses_on_race_id, :index_bk_race_result_horses_on_race_id
      rename_index :race_result_horses, :index_race_result_horses_on_speed_factor, :index_bk_race_result_horses_on_speed_factor
      rename_table :race_result_horses, :backup_race_result_horses

      rename_index :race_results, :index_race_results_on_age, :index_bk_race_results_on_age
      rename_index :race_results, :index_race_results_on_condition, :index_bk_race_results_on_condition
      rename_index :race_results, :index_race_results_on_date, :index_bk_race_results_on_date
      rename_index :race_results, :index_race_results_on_distance, :index_bk_race_results_on_distance
      rename_index :race_results, :index_race_results_on_female_only, :index_bk_race_results_on_female_only
      rename_index :race_results, :index_race_results_on_grade, :index_bk_race_results_on_grade
      rename_index :race_results, :index_race_results_on_male_only, :index_bk_race_results_on_male_only
      rename_index :race_results, :index_race_results_on_name, :index_bk_race_results_on_name
      rename_index :race_results, :index_race_results_on_number, :index_bk_race_results_on_number
      rename_index :race_results, :index_race_results_on_purse, :index_bk_race_results_on_purse
      rename_index :race_results, :index_race_results_on_race_type, :index_bk_race_results_on_race_type
      rename_index :race_results, :index_race_results_on_surface_id, :index_bk_race_results_on_surface_id
      rename_index :race_results, :index_race_results_on_time_in_seconds, :index_bk_race_results_on_time_in_seconds
      rename_table :race_results, :backup_race_results

      rename_index :race_schedules, :index_race_schedules_on_age, :index_bk_race_schedules_on_age
      rename_index :race_schedules, :index_race_schedules_on_date, :index_bk_race_schedules_on_date
      rename_index :race_schedules, :index_race_schedules_on_day_number, :index_bk_race_schedules_on_day_number
      rename_index :race_schedules, :index_race_schedules_on_distance, :index_bk_race_schedules_on_distance
      rename_index :race_schedules, :index_race_schedules_on_female_only, :index_bk_race_schedules_on_female_only
      rename_index :race_schedules, :index_race_schedules_on_grade, :index_bk_race_schedules_on_grade
      rename_index :race_schedules, :index_race_schedules_on_male_only, :index_bk_race_schedules_on_male_only
      rename_index :race_schedules, :index_race_schedules_on_name, :index_bk_race_schedules_on_name
      rename_index :race_schedules, :index_race_schedules_on_number, :index_bk_race_schedules_on_number
      rename_index :race_schedules, :index_race_schedules_on_purse, :index_bk_race_schedules_on_purse
      rename_index :race_schedules, :index_race_schedules_on_qualification_required, :index_bk_race_schedules_on_qual_required
      rename_index :race_schedules, :index_race_schedules_on_race_type, :index_bk_race_schedules_on_race_type
      rename_index :race_schedules, :index_race_schedules_on_surface_id, :index_bk_race_schedules_on_surface_id
      rename_table :race_schedules, :backup_race_schedules

      rename_index :racetracks, :index_racetracks_on_created_at, :index_bk_racetracks_on_created_at
      rename_index :racetracks, :index_racetracks_on_latitude, :index_bk_racetracks_on_latitude
      rename_index :racetracks, :index_racetracks_on_location_id, :index_bk_racetracks_on_location_id
      rename_index :racetracks, :index_racetracks_on_longitude, :index_bk_racetracks_on_longitude
      rename_index :racetracks, :index_racetracks_on_lowercase_name, :index_bk_racetracks_on_lowercase_name
      rename_table :racetracks, :backup_racetracks

      rename_index :sessions, :index_sessions_on_session_id, :index_bk_sessions_on_session_id
      rename_index :sessions, :index_sessions_on_updated_at, :index_bk_sessions_on_updated_at
      rename_index :sessions, :index_sessions_on_user_id, :index_bk_sessions_on_user_id
      rename_table :sessions, :backup_sessions

      rename_index :settings, :index_settings_on_user_id, :index_bk_settings_on_user_id
      rename_table :settings, :backup_settings

      rename_index :stables, :index_stables_on_created_at, :index_bk_stables_on_created_at
      rename_index :stables, :index_stables_on_last_online_at, :index_bk_stables_on_last_online_at
      rename_index :stables, :index_stables_on_legacy_id, :index_bk_stables_on_legacy_id
      rename_index :stables, :index_stables_on_name, :index_bk_stables_on_name
      rename_index :stables, :index_stables_on_racetrack_id, :index_bk_stables_on_racetrack_id
      rename_index :stables, :index_stables_on_user_id, :index_bk_stables_on_user_id
      rename_table :stables, :backup_stables

      rename_index :track_surfaces, :index_track_surfaces_on_racetrack_id_and_surface, :index_bk_surfaces_on_racetrack_id_and_surface
      rename_table :track_surfaces, :backup_track_surfaces

      rename_index :training_schedules, :index_training_schedules_on_friday_activities, :index_bk_training_schedules_on_friday_activities
      rename_index :training_schedules, :index_training_schedules_on_lowercase_name, :index_bk_training_schedules_on_lowercase_name
      rename_index :training_schedules, :index_training_schedules_on_monday_activities, :index_bk_training_schedules_on_monday_activities
      rename_index :training_schedules, :index_training_schedules_on_saturday_activities, :index_bk_training_schedules_on_saturday_activities
      rename_index :training_schedules, :index_training_schedules_on_stable_id, :index_bk_training_schedules_on_stable_id
      rename_index :training_schedules, :index_training_schedules_on_sunday_activities, :index_bk_training_schedules_on_sunday_activities
      rename_index :training_schedules, :index_training_schedules_on_thursday_activities, :index_bk_training_schedules_on_thursday_activities
      rename_index :training_schedules, :index_training_schedules_on_tuesday_activities, :index_bk_training_schedules_on_tuesday_activities
      rename_index :training_schedules, :index_training_schedules_on_wednesday_activities, :index_bk_training_schedules_on_wednesday_activities
      rename_table :training_schedules, :backup_training_schedules

      rename_index :training_schedules_horses, :index_training_schedules_horses_on_horse_id, :index_bk_training_schedules_horses_on_horse_id
      rename_index :training_schedules_horses, :index_training_schedules_horses_on_training_schedule_id, :index_bk_ts_horses_on_training_schedule_id
      rename_table :training_schedules_horses, :backup_training_schedules_horses

      rename_index :user_push_subscriptions, :index_user_push_subscriptions_on_user_id, :index_bk_user_push_subscriptions_on_user_id
      rename_table :user_push_subscriptions, :backup_user_push_subscriptions

      rename_index :users, :index_users_on_confirmation_token, :index_bk_users_on_confirmation_token
      rename_index :users, :index_users_on_created_at, :index_bk_users_on_created_at
      rename_index :users, :index_users_on_developer, :index_bk_users_on_developer
      rename_index :users, :index_users_on_discarded_at, :index_bk_users_on_discarded_at
      rename_index :users, :index_users_on_discourse_id, :index_bk_users_on_discourse_id
      rename_index :users, :index_users_on_email, :index_bk_users_on_email
      rename_index :users, :index_users_on_lowercase_username, :index_bk_users_on_lowercase_username
      rename_index :users, :index_users_on_reset_password_token, :index_bk_users_on_reset_password_token
      rename_index :users, :index_users_on_slug, :index_bk_users_on_slug
      rename_index :users, :index_users_on_unlock_token, :index_bk_users_on_unlock_token
      rename_table :users, :backup_users

      ###### NEW TABLES
      rename_index :new_activations, :index_new_activations_on_user_id, :index_activations_on_user_id
      rename_index :new_activations, :index_new_activations_on_old_user_id, :index_activations_on_old_user_id
      rename_table :new_activations, :activations

      rename_index :new_activity_points, :index_new_activity_points_on_activity_type, :index_activity_points_on_activity_type
      rename_index :new_activity_points, :index_new_activity_points_on_budget_id, :index_activity_points_on_budget_id
      rename_index :new_activity_points, :index_new_activity_points_on_old_budget_id, :index_activity_points_on_old_budget_id
      rename_index :new_activity_points, :index_new_activity_points_on_legacy_stable_id, :index_activity_points_on_legacy_stable_id
      rename_index :new_activity_points, :index_new_activity_points_on_stable_id, :index_activity_points_on_stable_id
      rename_index :new_activity_points, :index_new_activity_points_on_old_stable_id, :index_activity_points_on_old_stable_id
      rename_index :new_activity_points, :index_new_activity_points_on_old_id, :index_activity_points_on_old_id
      rename_table :new_activity_points, :activity_points

      rename_index :new_auction_bids, :index_new_auction_bids_on_auction_id, :index_auction_bids_on_auction_id
      rename_index :new_auction_bids, :index_new_auction_bids_on_bidder_id, :index_auction_bids_on_bidder_id
      rename_index :new_auction_bids, :index_new_auction_bids_on_horse_id, :index_auction_bids_on_horse_id
      rename_table :new_auction_bids, :auction_bids

      rename_index :new_auction_consignment_configs, :index_new_auction_consignment_configs_on_auction_id, :index_auction_consignment_configs_on_auction_id
      rename_table :new_auction_consignment_configs, :auction_consignment_configs

      rename_index :new_auction_horses, :index_new_auction_horses_on_auction_id, :index_auction_horses_on_auction_id
      rename_index :new_auction_horses, :index_new_auction_horses_on_old_auction_id, :index_auction_horses_on_old_auction_id
      rename_index :new_auction_horses, :index_new_auction_horses_on_horse_id, :index_auction_horses_on_horse_id
      rename_index :new_auction_horses, :index_new_auction_horses_on_old_horse_id, :index_auction_horses_on_old_horse_id
      rename_index :new_auction_horses, :index_new_auction_horses_on_sold_at, :index_auction_horses_on_sold_at
      rename_index :new_auction_horses, :index_new_auction_horses_on_old_id, :index_auction_horses_on_old_id
      rename_table :new_auction_horses, :auction_horses

      rename_index :new_auctions, :index_new_auctions_on_auctioneer_id, :index_auctions_on_auctioneer_id
      rename_index :new_auctions, :index_new_auctions_on_end_time, :index_auctions_on_end_time
      rename_index :new_auctions, :index_new_auctions_on_start_time, :index_auctions_on_start_time
      rename_index :new_auctions, :index_new_auctions_on_title, :index_auctions_on_title
      rename_table :new_auctions, :auctions

      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_born_foals_count, :index_broodmare_foal_records_on_born_foals_count
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_breed_ranking, :index_broodmare_foal_records_on_breed_ranking
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_horse_id, :index_broodmare_foal_records_on_horse_id
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_old_horse_id, :index_broodmare_foal_records_on_old_horse_id
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_millionaire_foals_count, :index_broodmare_foal_records_on_millionaire_foals_count
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_raced_foals_count, :index_broodmare_foal_records_on_raced_foals_count
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_stakes_winning_foals_count, :index_broodmare_foal_records_on_stakes_winning_foals_count
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_stillborn_foals_count, :index_broodmare_foal_records_on_stillborn_foals_count
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_total_foal_points, :index_broodmare_foal_records_on_total_foal_points
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_total_foal_races, :index_broodmare_foal_records_on_total_foal_races
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_unborn_foals_count, :index_broodmare_foal_records_on_unborn_foals_count
      rename_index :new_broodmare_foal_records, :index_new_broodmare_foal_records_on_winning_foals_count, :index_broodmare_foal_records_on_winning_foals_count
      rename_table :new_broodmare_foal_records, :broodmare_foal_records

      rename_index :new_budget_transactions, :index_new_budget_transactions_on_activity_type, :index_budget_transactions_on_activity_type
      rename_index :new_budget_transactions, :index_new_budget_transactions_on_description, :index_budget_transactions_on_description
      rename_index :new_budget_transactions, :index_new_budget_transactions_on_legacy_budget_id, :index_budget_transactions_on_legacy_budget_id
      rename_index :new_budget_transactions, :index_new_budget_transactions_on_legacy_stable_id, :index_budget_transactions_on_legacy_stable_id
      rename_index :new_budget_transactions, :index_new_budget_transactions_on_stable_id, :index_budget_transactions_on_stable_id
      rename_table :new_budget_transactions, :budget_transactions

      rename_index :new_game_activity_points, :index_new_game_activity_points_on_activity_type, :index_game_activity_points_on_activity_type
      rename_table :new_game_activity_points, :game_activity_points

      rename_index :new_game_alerts, :index_new_game_alerts_on_display_to_newbies, :index_game_alerts_on_display_to_newbies
      rename_index :new_game_alerts, :index_new_game_alerts_on_display_to_non_newbies, :index_game_alerts_on_display_to_non_newbies
      rename_index :new_game_alerts, :index_new_game_alerts_on_end_time, :index_game_alerts_on_end_time
      rename_index :new_game_alerts, :index_new_game_alerts_on_start_time, :index_game_alerts_on_start_time
      rename_table :new_game_alerts, :game_alerts

      rename_index :new_horse_appearances, :index_new_horse_appearances_on_horse_id, :index_horse_appearances_on_horse_id
      rename_table :new_horse_appearances, :horse_appearances

      rename_index :new_horse_attributes, :index_new_horse_attributes_on_horse_id, :index_horse_attributes_on_horse_id
      rename_table :new_horse_attributes, :horse_attributes

      rename_index :new_horse_genetics, :index_new_horse_genetics_on_horse_id, :index_horse_genetics_on_horse_id
      rename_table :new_horse_genetics, :horse_genetics

      rename_index :new_horsees, :index_new_horses_on_public_id, :index_horses_on_public_id
      rename_index :new_horsees, :index_new_horses_on_name, :index_horses_on_name
      rename_index :new_horsees, :index_new_horses_on_slug, :index_horses_on_slug
      rename_index :new_horsees, :index_new_horses_on_date_of_birth, :index_horses_on_date_of_birth
      rename_index :new_horsees, :index_new_horses_on_date_of_death, :index_horses_on_date_of_death
      rename_index :new_horsees, :index_new_horses_on_age, :index_horses_on_age
      rename_index :new_horsees, :index_new_horses_on_gender, :index_horses_on_gender
      rename_index :new_horsees, :index_new_horses_on_status, :index_horses_on_status
      rename_index :new_horsees, :index_new_horses_on_sire_id, :index_horses_on_sire_id
      rename_index :new_horsees, :index_new_horses_on_dam_id, :index_horses_on_dam_id
      rename_index :new_horsees, :index_new_horses_on_owner_id, :index_horses_on_owner_id
      rename_index :new_horsees, :index_new_horses_on_breeder_id, :index_horses_on_breeder_id
      rename_index :new_horsees, :index_new_horses_on_legacy_id, :index_horses_on_legacy_id
      rename_index :new_horsees, :index_new_horses_on_location_bred_id, :index_horses_on_location_bred_id
      rename_table :new_horses, :horses

      rename_index :new_jockeys, :index_new_jockeys_on_public_id, :index_jockeys_on_public_id
      rename_index :new_jockeys, :index_new_jockeys_on_first_name, :index_jockeys_on_first_name
      rename_index :new_jockeys, :index_new_jockeys_on_last_name, :index_jockeys_on_last_name
      rename_index :new_jockeys, :index_new_jockeys_on_date_of_birth, :index_jockeys_on_date_of_birth
      rename_index :new_jockeys, :index_new_jockeys_on_status, :index_jockeys_on_status
      rename_index :new_jockeys, :index_new_jockeys_on_jockey_type, :index_jockeys_on_jockey_type
      rename_index :new_jockeys, :index_new_jockeys_on_height_in_inches, :index_jockeys_on_height_in_inches
      rename_index :new_jockeys, :index_new_jockeys_on_weight, :index_jockeys_on_weight
      rename_index :new_jockeys, :index_new_jockeys_on_slug, :index_jockeys_on_slug
      rename_index :new_jockeys, :index_new_jockeys_on_gender, :index_jockeys_on_gender
      rename_index :new_jockeys, :index_new_jockeys_on_legacy_id, :index_jockeys_on_legacy_id
      rename_table :new_jockeys, :jockeys

      rename_index :new_locations, :index_new_locations_on_name, :index_locations_on_name
      rename_table :new_locations, :locations

      rename_index :new_race_odds, :index_new_race_odds_on_display, :index_race_odds_on_display
      rename_table :new_race_odds, :race_odds

      rename_index :new_race_records, :index_new_race_records_on_horse_id, :index_race_records_on_horse_id
      rename_index :new_race_records, :index_new_race_records_on_year, :index_race_records_on_year
      rename_index :new_race_records, :index_new_race_records_on_result_type, :index_race_records_on_result_type
      rename_index :new_race_records, :index_new_race_records_on_starts, :index_race_records_on_starts
      rename_index :new_race_records, :index_new_race_records_on_stakes_starts, :index_race_records_on_stakes_starts
      rename_index :new_race_records, :index_new_race_records_on_wins, :index_race_records_on_wins
      rename_index :new_race_records, :index_new_race_records_on_stakes_wins, :index_race_records_on_stakes_wins
      rename_table :new_race_records, :race_records

      rename_index :new_race_result_horses, :index_new_race_result_horses_on_race_id, :index_race_result_horses_on_race_id
      rename_index :new_race_result_horses, :index_new_race_result_horses_on_horse_id, :index_race_result_horses_on_horse_id
      rename_index :new_race_result_horses, :index_new_race_result_horses_on_legacy_horse_id, :index_race_result_horses_on_legacy_horse_id
      rename_index :new_race_result_horses, :index_new_race_result_horses_on_finish_position, :index_race_result_horses_on_finish_position
      rename_index :new_race_result_horses, :index_new_race_result_horses_on_jockey_id, :index_race_result_horses_on_jockey_id
      rename_index :new_race_result_horses, :index_new_race_result_horses_on_speed_factor, :index_race_result_horses_on_speed_factor
      rename_table :new_race_result_horses, :race_result_horses

      rename_index :new_race_results, :index_new_race_results_on_date, :index_race_results_on_date
      rename_index :new_race_results, :index_new_race_results_on_number, :index_race_results_on_number
      rename_index :new_race_results, :index_new_race_results_on_race_type, :index_race_results_on_race_type
      rename_index :new_race_results, :index_new_race_results_on_age, :index_race_results_on_age
      rename_index :new_race_results, :index_new_race_results_on_distance, :index_race_results_on_distance
      rename_index :new_race_results, :index_new_race_results_on_grade, :index_race_results_on_grade
      rename_index :new_race_results, :index_new_race_results_on_surface_id, :index_race_results_on_surface_id
      rename_index :new_race_results, :index_new_race_results_on_condition, :index_race_results_on_condition
      rename_index :new_race_results, :index_new_race_results_on_name, :index_race_results_on_name
      rename_index :new_race_results, :index_new_race_results_on_purse, :index_race_results_on_purse
      rename_index :new_race_results, :index_new_race_results_on_time_in_seconds, :index_race_results_on_time_in_seconds
      rename_index :new_race_results, :index_new_race_results_on_slug, :index_race_results_on_slug
      rename_table :new_race_results, :race_results

      rename_index :new_race_schedules, :index_new_race_schedules_on_day_number, :index_race_schedules_on_day_number
      rename_index :new_race_schedules, :index_new_race_schedules_on_date, :index_race_schedules_on_date
      rename_index :new_race_schedules, :index_new_race_schedules_on_number, :index_race_schedules_on_number
      rename_index :new_race_schedules, :index_new_race_schedules_on_race_type, :index_race_schedules_on_race_type
      rename_index :new_race_schedules, :index_new_race_schedules_on_age, :index_race_schedules_on_age
      rename_index :new_race_schedules, :index_new_race_schedules_on_male_only, :index_race_schedules_on_male_only
      rename_index :new_race_schedules, :index_new_race_schedules_on_female_only, :index_race_schedules_on_female_only
      rename_index :new_race_schedules, :index_new_race_schedules_on_distance, :index_race_schedules_on_distance
      rename_index :new_race_schedules, :index_new_race_schedules_on_grade, :index_race_schedules_on_grade
      rename_index :new_race_schedules, :index_new_race_schedules_on_surface_id, :index_race_schedules_on_surface_id
      rename_index :new_race_schedules, :index_new_race_schedules_on_name, :index_race_schedules_on_name
      rename_index :new_race_schedules, :index_new_race_schedules_on_qualification_required, :index_race_schedules_on_qualification_required
      rename_table :new_race_schedules, :race_schedules

      rename_index :new_racetracks, :index_new_racetracks_on_name, :index_racetracks_on_name
      rename_index :new_racetracks, :index_new_racetracks_on_slug, :index_racetracks_on_slug
      rename_index :new_racetracks, :index_new_racetracks_on_public_id, :index_racetracks_on_public_id
      rename_index :new_racetracks, :index_new_racetracks_on_location_id, :index_racetracks_on_location_id
      rename_table :new_racetracks, :racetracks

      rename_index :new_sessions, :index_new_sessions_on_session_id, :index_sessions_on_session_id
      rename_index :new_sessions, :index_new_sessions_on_user_id, :index_sessions_on_user_id
      rename_table :new_sessions, :sessions

      rename_index :new_settings, :index_new_settings_on_user_id, :index_settings_on_user_id
      rename_table :new_settings, :settings

      rename_index :new_stables, :index_new_stables_on_name, :index_stables_on_name
      rename_index :new_stables, :index_new_stables_on_legacy_id, :index_stables_on_legacy_id
      rename_index :new_stables, :index_new_stables_on_slug, :index_stables_on_slug
      rename_index :new_stables, :index_new_stables_on_public_id, :index_stables_on_public_id
      rename_index :new_stables, :index_new_stables_on_available_balance, :index_stables_on_available_balance
      rename_index :new_stables, :index_new_stables_on_total_balance, :index_stables_on_total_balance
      rename_index :new_stables, :index_new_stables_on_last_online_at, :index_stables_on_last_online_at
      rename_index :new_stables, :index_new_stables_on_racetrack_id, :index_stables_on_racetrack_id
      rename_index :new_stables, :index_new_stables_on_user_id, :index_stables_on_user_id
      rename_table :new_stables, :stables

      rename_index :new_track_surfaces, :index_new_track_surfaces_on_racetrack_id, :index_track_surfaces_on_racetrack_id
      rename_table :new_track_surfaces, :track_surfaces

      rename_index :new_training_schedules, :index_new_training_schedules_on_stable_id, :index_training_schedules_on_stable_id
      rename_index :new_training_schedules, :index_new_training_schedules_on_horses_count, :index_training_schedules_on_horses_count
      rename_index :new_training_schedules, :index_new_training_schedules_on_monday_activities, :index_training_schedules_on_monday_activities
      rename_index :new_training_schedules, :index_new_training_schedules_on_tuesday_activities, :index_training_schedules_on_tuesday_activities
      rename_index :new_training_schedules, :index_new_training_schedules_on_wednesday_activities, :index_training_schedules_on_wednesday_activities
      rename_index :new_training_schedules, :index_new_training_schedules_on_thursday_activities, :index_training_schedules_on_thursday_activities
      rename_index :new_training_schedules, :index_new_training_schedules_on_friday_activities, :index_training_schedules_on_friday_activities
      rename_index :new_training_schedules, :index_new_training_schedules_on_saturday_activities, :index_training_schedules_on_saturday_activities
      rename_index :new_training_schedules, :index_new_training_schedules_on_sunday_activities, :index_training_schedules_on_sunday_activities
      rename_table :new_training_schedules, :training_schedules

      rename_index :new_training_schedules_horses, :index_new_training_schedules_horses_on_horse_id, :index_training_schedules_horses_on_horse_id
      rename_index :new_training_schedules_horses, :index_new_training_schedules_horses_on_training_schedule_id, :index_training_schedules_horses_on_training_schedule_id
      rename_table :new_training_schedules_horses, :training_schedules_horses

      rename_index :new_user_push_subscriptions, :index_new_user_push_subscriptions_on_user_id, :index_user_push_subscriptions_on_user_id
      rename_table :new_user_push_subscriptions, :user_push_subscriptions

      rename_index :new_users, :index_new_users_on_slug, :index_users_on_slug
      rename_index :new_users, :index_new_users_on_username, :index_users_on_username
      rename_index :new_users, :index_new_users_on_public_id, :index_users_on_public_id
      rename_index :new_users, :index_new_users_on_discourse_id, :index_users_on_discourse_id
      rename_index :new_users, :index_new_users_on_email, :index_users_on_email
      rename_index :new_users, :index_new_users_on_name, :index_users_on_name
      rename_index :new_users, :index_new_users_on_admin, :index_users_on_admin
      rename_index :new_users, :index_new_users_on_developer, :index_users_on_developer
      rename_table :new_users, :users

      # rubocop:disable Rails/ReversibleMigration
      change_column :activations, :user_id, :bigint
      change_column :budget_transactions, :stable_id, :bigint
      change_column :activity_points, :budget_id, :bigint
      change_column :activity_points, :stable_id, :bigint
      change_column :stables, :user_id, :bigint
      change_column :stables, :racetrack_id, :bigint
      change_column :auctions, :auctioneer_id, :bigint
      change_column :auction_consignment_configs, :auction_id, :bigint
      change_column :auction_bids, :auction_id, :bigint
      change_column :auction_bids, :bidder_id, :bigint
      change_column :auction_bids, :horse_id, :bigint
      change_column :auction_horses, :auction_id, :bigint
      change_column :auction_horses, :horse_id, :bigint
      change_column :horses, :owner_id, :bigint
      change_column :horses, :breeder_id, :bigint
      change_column :horses, :sire_id, :bigint
      change_column :horses, :dam_id, :bigint
      change_column :broodmare_foal_records, :horse_id, :bigint
      change_column :horse_appearances, :horse_id, :bigint
      change_column :horse_attributes, :horse_id, :bigint
      change_column :horse_genetics, :horse_id, :bigint
      change_column :race_records, :horse_id, :bigint
      change_column :track_surfaces, :racetrack_id, :bigint
      change_column :race_results, :surface_id, :bigint
      change_column :race_result_horses, :race_id, :bigint
      change_column :race_result_horses, :horse_id, :bigint
      change_column :race_result_horses, :odd_id, :bigint
      change_column :race_result_horses, :jockey_id, :bigint
      change_column :race_schedules, :surface_id, :bigint
      change_column :racetracks, :location_id, :bigint
      change_column :settings, :user_id, :bigint
      change_column :training_schedules_horses, :horse_id, :bigint
      change_column :training_schedules_horses, :training_schedule_id, :bigint
      change_column :training_schedules, :stable_id, :bigint
      change_column :user_push_subscriptions, :user_id, :bigint
      # rubocop:enable Rails/ReversibleMigration
    end

    add_foreign_key :activations, :users, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :activity_points, :budget_transactions, column: :budget_id, on_delete: :nullify, on_update: :cascade, validate: false
    add_foreign_key :activity_points, :stables, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :auction_consignment_configs, :auctions, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :auctions, :stables, column: :auctioneer_id, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :auction_bids, :auctions, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :auction_bids, :auction_horses, column: :horse_id, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :auction_bids, :stables, column: :bidder_id, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :auction_horses, :auctions, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :auction_horses, :horses, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :broodmare_foal_records, :horses, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :budget_transactions, :stables, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :horse_appearances, :horses, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :horse_attributes, :horses, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :horse_genetics, :horses, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :horses, :stables, column: :breeder_id, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :horses, :stables, column: :owner_id, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :horses, :horses, column: :sire_id, on_delete: :nullify, on_update: :cascade, validate: false
    add_foreign_key :horses, :horses, column: :dam_id, on_delete: :nullify, on_update: :cascade, validate: false
    add_foreign_key :horses, :locations, column: :location_bred_id, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :race_records, :horses, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :race_results, :track_surfaces, column: :surface_id, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :race_result_horses, :race_results, column: :race_id, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :race_result_horses, :horses, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :race_result_horses, :jockeys, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :race_result_horses, :race_results, column: :odd_id, on_delete: :nullify, on_update: :cascade, validate: false
    add_foreign_key :race_schedules, :track_surfaces, column: :surface_id, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :racetracks, :locations, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :settings, :users, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :stables, :racetracks, on_delete: :nullify, on_update: :cascade, validate: false
    add_foreign_key :stables, :users, on_delete: :restrict, on_update: :cascade, validate: false
    add_foreign_key :track_surfaces, :racetracks, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :training_schedules_horses, :horses, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :training_schedules_horses, :training_schedules, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :training_schedules, :stables, on_delete: :cascade, on_update: :cascade, validate: false
    add_foreign_key :user_push_subscriptions, :users, on_delete: :cascade, on_update: :cascade, validate: false
  end
end

