class AddIndexToRaceRecords < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :annual_race_records, %i[year horse_id], unique: true, algorithm: :concurrently
    add_index :annual_race_records, %i[horse_id], algorithm: :concurrently
    add_index :sale_offers, %i[buyer_id new_members_only], algorithm: :concurrently
    remove_index :sale_offers, :buyer_id, if_exists: true
  end
end

