class AddUniqueHorseIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :race_options, column: :horse_id, if_exists: true
    add_index :race_options, :horse_id, unique: true, algorithm: :concurrently

    remove_index :racehorse_stats, column: :horse_id, if_exists: true
    add_index :racehorse_stats, :horse_id, unique: true, algorithm: :concurrently
  end
end

