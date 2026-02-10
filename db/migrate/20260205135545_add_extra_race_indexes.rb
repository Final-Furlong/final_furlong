class AddExtraRaceIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :race_entries, :odd_id, algorithm: :concurrently
    add_index :race_qualifications, :horse_id, unique: true, algorithm: :concurrently
  end
end

