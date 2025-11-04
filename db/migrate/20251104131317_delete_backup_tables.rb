class DeleteBackupTables < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :backup_activations
    drop_table :backup_activity_points
    drop_table :backup_auction_bids
    drop_table :backup_auction_consignment_configs
    drop_table :backup_auction_horses
    drop_table :backup_auctions
    drop_table :backup_broodmare_foal_records
    drop_table :backup_budgets
    drop_table :backup_game_activity_points
    drop_table :backup_game_alerts
    drop_table :backup_horse_appearances
    drop_table :backup_horse_attributes
    drop_table :backup_horse_genetics
    drop_table :backup_race_result_horses
    drop_table :backup_race_results
    drop_table :backup_race_records
    drop_table :backup_training_schedules_horses
    drop_table :backup_horses
    drop_table :backup_jockeys
    drop_table :backup_race_odds
    drop_table :backup_race_schedules
    drop_table :backup_track_surfaces
    drop_table :backup_training_schedules
    drop_table :backup_stables
    drop_table :backup_racetracks
    drop_table :backup_sessions
    drop_table :backup_settings
    drop_table :backup_user_push_subscriptions
    drop_table :backup_users
    drop_table :backup_locations
    # rubocop:enable Rails/ReversibleMigration
  end
end

