class UpdateRacetrackBoardingIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :boardings, column: :horse_id, if_exists: true

    remove_index :racetracks, column: :location_id, if_exists: true
    add_index :racetracks, :location_id, unique: true, algorithm: :concurrently
  end
end

