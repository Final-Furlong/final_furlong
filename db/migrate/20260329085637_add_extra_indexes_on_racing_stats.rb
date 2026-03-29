class AddExtraIndexesOnRacingStats < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :racing_stats, :energy, algorithm: :concurrently, if_not_exists: true
    add_index :racing_stats, :natural_energy_gain, algorithm: :concurrently, if_not_exists: true
    add_index :racing_stats, :fitness, algorithm: :concurrently, if_not_exists: true
    add_index :racing_stats, :xp_current, algorithm: :concurrently, if_not_exists: true
  end
end

