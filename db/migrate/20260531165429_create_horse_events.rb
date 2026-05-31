class CreateHorseEvents < ActiveRecord::Migration[8.1]
  def change
    horse_events = %w[gelded switched_to_sc retired_racing retired_breeding]
    create_enum :horse_event_types, horse_events

    create_table :horse_events do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.enum :event_type, enum_type: :horse_event_types, index: true, comment: horse_events.join(",")
      t.date :date, null: false, index: true

      t.timestamps
    end

    add_index :horse_events, %i[horse_id event_type], unique: true
  end
end

