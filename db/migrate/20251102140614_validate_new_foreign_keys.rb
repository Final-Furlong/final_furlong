class ValidateNewForeignKeys < ActiveRecord::Migration[8.1]
  def change
    validate_foreign_key :activations, :users
    validate_foreign_key :activity_points, :budget_transactions
    validate_foreign_key :activity_points, :stables
    validate_foreign_key :auction_consignment_configs, :auctions
    validate_foreign_key :auctions, :stables
    validate_foreign_key :auction_bids, :auctions
    validate_foreign_key :auction_bids, :auction_horses
    validate_foreign_key :auction_bids, :stables
    validate_foreign_key :auction_horses, :auctions
    validate_foreign_key :auction_horses, :horses
    validate_foreign_key :broodmare_foal_records, :horses
    validate_foreign_key :budget_transactions, :stables
    validate_foreign_key :horse_appearances, :horses
    validate_foreign_key :horse_attributes, :horses
    validate_foreign_key :horse_genetics, :horses
    validate_foreign_key :horses, :stables
    validate_foreign_key :horses, :stables
    validate_foreign_key :horses, :horses
    validate_foreign_key :horses, :horses
    validate_foreign_key :horses, :locations
    validate_foreign_key :race_records, :horses
    validate_foreign_key :race_results, :track_surfaces
    validate_foreign_key :race_result_horses, :race_results
    validate_foreign_key :race_result_horses, :horses
    validate_foreign_key :race_result_horses, :jockeys
    validate_foreign_key :race_result_horses, :race_results
    validate_foreign_key :race_schedules, :track_surfaces
    validate_foreign_key :racetracks, :locations
    validate_foreign_key :settings, :users
    validate_foreign_key :stables, :racetracks
    validate_foreign_key :stables, :users
    validate_foreign_key :track_surfaces, :racetracks
    validate_foreign_key :training_schedules_horses, :horses
    validate_foreign_key :training_schedules_horses, :training_schedules
    validate_foreign_key :training_schedules, :stables
    validate_foreign_key :user_push_subscriptions, :users
  end
end

