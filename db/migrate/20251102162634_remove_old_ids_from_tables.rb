class RemoveOldIdsFromTables < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      # rubocop:disable Rails/ReversibleMigration
      remove_column :activations, :old_user_id
      remove_column :activity_points, :old_stable_id
      remove_column :activity_points, :old_id
      remove_column :budget_transactions, :old_stable_id
      remove_column :user_push_subscriptions, :old_user_id
      remove_column :settings, :old_user_id
      remove_column :stables, :old_user_id
      remove_column :stables, :old_id
      remove_column :auctions, :old_auctioneer_id
      remove_column :auction_bids, :old_auction_id
      remove_column :auction_bids, :old_bidder_id
      remove_column :auction_bids, :old_horse_id
      remove_column :auction_consignment_configs, :old_auction_id
      remove_column :auction_horses, :old_auction_id
      remove_column :auction_horses, :old_horse_id
      remove_column :horse_appearances, :old_horse_id
      remove_column :horse_attributes, :old_horse_id
      remove_column :horse_genetics, :old_horse_id
      remove_column :broodmare_foal_records, :old_horse_id
      remove_column :horses, :old_owner_id
      remove_column :horses, :old_breeder_id
      remove_column :horses, :old_location_bred_id
      remove_column :race_records, :old_horse_id
      remove_column :race_records, :old_id
      remove_column :race_results, :old_surface_id
      remove_column :race_result_horses, :old_horse_id
      remove_column :race_result_horses, :old_race_id
      remove_column :race_schedules, :old_surface_id
      remove_column :racetracks, :old_location_id
      remove_column :track_surfaces, :old_racetrack_id
      remove_column :training_schedules, :old_stable_id
      remove_column :training_schedules_horses, :old_horse_id
      remove_column :training_schedules_horses, :old_training_schedule_id
      # rubocop:enable Rails/ReversibleMigration
    end
  end
end

