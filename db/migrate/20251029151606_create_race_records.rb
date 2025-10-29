class CreateRaceRecords < ActiveRecord::Migration[8.1]
  def change
    race_types = %w[dirt turf steeplechase]
    create_enum :race_result_types, race_types

    create_table :race_records, id: :uuid do |t|
      t.references :horse, type: :uuid, null: false, index: true, foreign_key: { to_table: :horses }
      t.integer :year, default: 1996, null: false, index: true
      t.enum :result_type, enum_type: "race_result_types", default: "dirt", index: true, comment: race_types.join(", ")
      t.integer :starts, default: 0, null: false
      t.integer :stakes_starts, default: 0, null: false
      t.integer :wins, default: 0, null: false
      t.integer :stakes_wins, default: 0, null: false
      t.integer :seconds, default: 0, null: false
      t.integer :stakes_seconds, default: 0, null: false
      t.integer :thirds, default: 0, null: false
      t.integer :stakes_thirds, default: 0, null: false
      t.integer :fourths, default: 0, null: false
      t.integer :stakes_fourths, default: 0, null: false
      t.integer :points, default: 0, null: false
      t.bigint :earnings, default: 0, null: false

      t.timestamps
    end
  end
end

