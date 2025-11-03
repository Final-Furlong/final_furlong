class SwitchJockeyIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :jockeys, column: :first_name, if_exists: true
    add_index :jockeys, "first_name, lower(last_name)", name: "index_jockeys_on_unique_name", unique: true, algorithm: :concurrently
  end
end

