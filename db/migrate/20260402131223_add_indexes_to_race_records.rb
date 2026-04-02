class AddIndexesToRaceRecords < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :race_records, %i[horse_id year surface], unique: true, algorithm: :concurrently, if_not_exists: true
  end
end

