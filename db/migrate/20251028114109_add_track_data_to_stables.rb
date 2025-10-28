class AddTrackDataToStables < ActiveRecord::Migration[8.0]
  def change
    add_reference :stables, :racetrack, type: :uuid, index: true, foreign_key: { to_table: :racetracks }
    add_column :stables, :miles_from_track, :integer, default: 1, null: false
  end
end

