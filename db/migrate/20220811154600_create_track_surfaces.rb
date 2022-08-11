class CreateTrackSurfaces < ActiveRecord::Migration[7.0]
  def change
    create_enum :track_surface, %w[dirt turf steeplechase]
    create_enum :track_condition, %w[fast good slow wet]

    create_table :track_surfaces, id: :uuid do |t|
      t.references :racetrack, type: :uuid, index: true, foreign_key: true
      t.enum :surface, enum_type: "track_surface", default: "dirt", null: false,
                       comment: "dirt, turf, steeplechase"
      t.enum :condition, enum_type: "track_condition", default: "fast", null: false,
                         comment: "fast, good, slow, wet"
      t.integer :width, null: false
      t.integer :length, null: false
      t.integer :turn_to_finish_length, null: false
      t.integer :turn_distance, null: false
      t.integer :banking, null: false
      t.integer :jumps, default: 0, null: false

      # "ID","Name","Abbr","Location","DTSC","Condition","Width","Length","TurnToFinish","TurnDistance","Banking","Jumps"
      t.timestamps
    end
  end
end
