class AddStableIdToRaceResultHorse < ActiveRecord::Migration[8.1]
  def change
    add_reference :race_result_horses, :stable, type: :bigint, index: true, foreign_key: { to_table: :stables }
  end
end

