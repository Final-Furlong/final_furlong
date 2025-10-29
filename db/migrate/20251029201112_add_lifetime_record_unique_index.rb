class AddLifetimeRecordUniqueIndex < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :lifetime_race_records, :horse_id, unique: true, algorithm: :concurrently
  end
end

