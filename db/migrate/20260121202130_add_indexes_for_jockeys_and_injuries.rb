class AddIndexesForJockeysAndInjuries < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :horse_jockey_relationships, :jockey_id, algorithm: :concurrently
    add_index :injuries, :horse_id, algorithm: :concurrently
    add_index :historical_injuries, :horse_id, algorithm: :concurrently
  end
end

