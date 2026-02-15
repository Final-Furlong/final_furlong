class CreateFutureEvents < ActiveRecord::Migration[8.1]
  def change
    event_types = %w[retire die nominate]
    create_enum :future_event_types, event_types
    create_table :future_events do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.enum :event_type, enum_type: :future_event_types, null: false, index: true, comment: event_types.join(", ")
      t.date :date, null: false, index: true

      t.timestamps
    end

    add_index :future_events, %i[horse_id event_type], unique: true
  end
end

