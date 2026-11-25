class CreateUniqueColumnsForViewsV2 < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :race_qualifications, :horse_id, unique: true, if_not_exists: true, algorithm: :concurrently
  end
end

