class ActiveRecorDoctorFixesForNewTables < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :race_result_horses, :odd_id, algorithm: :concurrently

    change_column_null :activations, :user_id, false
    change_column_null :activity_points, :stable_id, false
    change_column_null :user_push_subscriptions, :user_id, false
    change_column_null :settings, :user_id, false
    change_column_null :stables, :user_id, false
    change_column_null :auctions, :auctioneer_id, false
    change_column_null :auction_bids, :auction_id, false
    change_column_null :auction_bids, :horse_id, false
    change_column_null :auction_bids, :bidder_id, false
    change_column_null :auction_horses, :auction_id, false
    change_column_null :auction_horses, :horse_id, false
    change_column_null :auction_consignment_configs, :auction_id, false
    change_column_null :horse_appearances, :birth_height, false
    change_column_null :horse_appearances, :current_height, false
    change_column_null :horse_appearances, :max_height, false
    change_column_null :horse_appearances, :horse_id, false
    change_column_null :broodmare_foal_records, :horse_id, false
    change_column_null :horse_genetics, :horse_id, false
    change_column_null :horses, :owner_id, false
    change_column_null :horses, :breeder_id, false
    change_column_null :horses, :location_bred_id, false
    change_column_null :race_records, :horse_id, false
    change_column_null :race_results, :surface_id, false
    change_column_null :race_result_horses, :horse_id, false
    change_column_null :race_result_horses, :race_id, false
    change_column_null :race_schedules, :surface_id, false
    change_column_null :racetracks, :location_id, false
    change_column_null :track_surfaces, :racetrack_id, false
    change_column_null :training_schedules, :stable_id, false
    change_column_null :training_schedules_horses, :horse_id, false
    change_column_null :training_schedules_horses, :training_schedule_id, false

    remove_index :stables, column: :name, if_exists: true
    ActiveRecord::Base.connection.execute "CREATE UNIQUE INDEX index_stables_on_name ON stables USING btree (lower(name));"

    remove_index :auctions, column: :title, if_exists: true
    ActiveRecord::Base.connection.execute "CREATE UNIQUE INDEX index_auctions_on_title ON auctions USING btree (lower(title));"

    remove_index :auction_consignment_configs, column: %i[aucion_id horse_type], if_exists: true
    ActiveRecord::Base.connection.execute "CREATE UNIQUE INDEX index_auction_configs_on_horse_type ON auction_consignment_configs (auction_id, lower(horse_type));"

    remove_index :auction_horses, column: :horse_id, if_exists: true
    add_index :auction_horses, :horse_id, unique: true, algorithm: :concurrently

    remove_index :locations, column: %i[country name], if_exists: true
    add_index :locations, %i[country name], unique: true, algorithm: :concurrently

    remove_index :race_records, column: %i[horse_id year result_type], if_exists: true
    add_index :race_records, %i[horse_id year result_type], unique: true, algorithm: :concurrently

    remove_index :racetracks, column: :name, if_exists: true
    ActiveRecord::Base.connection.execute "CREATE UNIQUE INDEX index_racetracks_on_name ON racetracks USING btree (lower(name));"

    remove_index :track_surfaces, column: %i[racetrack_id surface], if_exists: true
    add_index :track_surfaces, %i[racetrack_id surface], unique: true, algorithm: :concurrently

    remove_index :training_schedules, column: %i[stable_id name], if_exists: true
    ActiveRecord::Base.connection.execute "CREATE UNIQUE INDEX index_training_schedules_on_stable_and_name ON training_schedules (stable_id, lower(name));"

    remove_index :training_schedules_horses, column: :horse_id, if_exists: true
    add_index :training_schedules_horses, :horse_id, unique: true, algorithm: :concurrently

    remove_index :stables, column: :user_id, if_exists: true
    add_index :stables, :user_id, unique: true, algorithm: :concurrently

    remove_index :settings, column: :user_id, if_exists: true
    add_index :settings, :user_id, unique: true, algorithm: :concurrently

    remove_index :horse_attributes, column: :horse_id, if_exists: true
    add_index :horse_attributes, :horse_id, unique: true, algorithm: :concurrently

    remove_index :horse_appearances, column: :horse_id, if_exists: true
    add_index :horse_appearances, :horse_id, unique: true, algorithm: :concurrently

    remove_index :horse_genetics, column: :horse_id, if_exists: true
    add_index :horse_genetics, :horse_id, unique: true, algorithm: :concurrently

    remove_index :auction_horses, column: :horse_id, if_exists: true
    add_index :auction_horses, :horse_id, unique: true, algorithm: :concurrently

    remove_index :broodmare_foal_records, column: :horse_id, if_exists: true
    add_index :broodmare_foal_records, :horse_id, unique: true, algorithm: :concurrently
  end
end

