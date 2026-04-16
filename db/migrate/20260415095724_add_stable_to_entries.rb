class AddStableToEntries < ActiveRecord::Migration[8.1]
  def change
    add_reference :race_entries, :stable, index: true, foreign_key: { to_table: :stables }
    add_reference :future_race_entries, :stable, index: true, foreign_key: { to_table: :stables }
  end
end

