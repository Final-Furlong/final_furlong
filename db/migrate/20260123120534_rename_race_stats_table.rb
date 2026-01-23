class RenameRaceStatsTable < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      rename_table :racehorse_stats, :racehorse_metadata
    end
  end
end

