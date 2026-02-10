class AddUniqueIndexForJockeysOnRaceOptions < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :race_options, [:horse_id, :first_jockey_id, :second_jockey_id, :third_jockey_id], unique: true, algorithm: :concurrently
  end
end

