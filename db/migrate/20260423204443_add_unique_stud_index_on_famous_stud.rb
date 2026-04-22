class AddUniqueStudIndexOnFamousStud < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :famous_studs, :horse_id, if_exists: true
    add_index :famous_studs, :horse_id, unique: true, algorithm: :concurrently
  end
end

