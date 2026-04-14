class AddRaceRelatedIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :race_entries, %i[race_id jockey_id], if_exists: true
    remove_index :race_entries, :race_id, if_exists: true
    add_index :race_entries, %i[race_id jockey_id], unique: true, algorithm: :concurrently
    add_index :race_qualifications, :allowance_placed, algorithm: :concurrently
    add_index :race_qualifications, :stakes_placed, algorithm: :concurrently
    add_index :race_qualifications, :claiming_qualified, algorithm: :concurrently
    add_index :race_qualifications, :maiden_qualified, algorithm: :concurrently
    add_index :race_qualifications, :nw1_allowance_qualified, algorithm: :concurrently
    add_index :race_qualifications, :nw2_allowance_qualified, algorithm: :concurrently
    add_index :race_qualifications, :nw3_allowance_qualified, algorithm: :concurrently
    add_index :race_qualifications, :starter_allowance_qualified, algorithm: :concurrently
  end
end

