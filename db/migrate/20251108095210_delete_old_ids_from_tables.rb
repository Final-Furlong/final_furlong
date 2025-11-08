class DeleteOldIdsFromTables < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      remove_column :activity_points, :old_budget_id, if_exists: true
      remove_column :game_activity_points, :old_id, if_exists: true
      remove_column :game_alerts, :old_id, if_exists: true
      remove_column :horse_appearances, :old_id, if_exists: true
      remove_column :horse_attributes, :old_id, if_exists: true
      remove_column :horse_genetics, :old_id, if_exists: true
      remove_column :auctions, :old_id, if_exists: true
      remove_column :auction_bids, :old_id, if_exists: true
      remove_column :auction_consignment_configs, :old_id, if_exists: true
      remove_column :auction_horses, :old_id, if_exists: true
      remove_column :broodmare_foal_records, :old_id, if_exists: true
      remove_column :budget_transactions, :old_id, if_exists: true
      remove_column :horses, :old_id, if_exists: true
      remove_column :horses, :old_dam_id, if_exists: true
      remove_column :horses, :old_sire_id, if_exists: true
      remove_column :jockeys, :old_id, if_exists: true
      remove_column :locations, :old_id, if_exists: true
      remove_column :race_odds, :old_id, if_exists: true
      remove_column :race_results, :old_id, if_exists: true
      remove_column :race_result_horses, :old_id, if_exists: true
      remove_column :race_result_horses, :old_jockey_id, if_exists: true
      remove_column :race_result_horses, :old_odd_id, if_exists: true
      remove_column :race_schedules, :old_id, if_exists: true
      remove_column :racetracks, :old_id, if_exists: true
      remove_column :settings, :old_id, if_exists: true
      remove_column :stables, :old_racetrack_id, if_exists: true
      remove_column :track_surfaces, :old_id, if_exists: true
      remove_column :training_schedules_horses, :old_id, if_exists: true
      remove_column :user_push_subscriptions, :old_id, if_exists: true
    end
  end
end

