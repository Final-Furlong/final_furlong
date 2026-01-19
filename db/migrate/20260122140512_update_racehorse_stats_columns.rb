class UpdateRacehorseStatsColumns < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_column :racehorse_stats, :rest_days_since_last_race, :integer, null: false, default: 0
    add_column :racehorse_stats, :workouts_since_last_race, :integer, null: false, default: 0

    add_index :racehorse_stats, :rest_days_since_last_race, algorithm: :concurrently
    add_index :racehorse_stats, :workouts_since_last_race, algorithm: :concurrently
  end
end

