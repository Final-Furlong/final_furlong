class AddMoreUniqueIndexes < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    remove_index :horse_appearances, :horse_id if index_exists? :horse_appearances, :horse_id
    add_index :horse_appearances, :horse_id, unique: true, algorithm: :concurrently

    remove_index :horse_genetics, :horse_id if index_exists? :horse_appearances, :horse_id
    add_index :horse_genetics, :horse_id, unique: true, algorithm: :concurrently
  end
end

