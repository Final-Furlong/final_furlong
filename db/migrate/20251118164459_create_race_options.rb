class CreateRaceOptions < ActiveRecord::Migration[8.1]
  def change
    racing_styles = %w[leading off_pace midpack closing]
    create_enum :racing_style, racing_styles
    racehorse_types = %w[flat jump]
    create_enum :racehorse_type, racehorse_types

    create_table :race_options do |t|
      t.references :horse, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }
      t.enum :racehorse_type, enum_type: "racehorse_type", comment: racehorse_types.join(","), index: true
      t.decimal :minimum_distance, precision: 3, scale: 1, default: 5.0, null: false, index: true
      t.decimal :maximum_distance, precision: 3, scale: 1, default: 24.0, null: false, index: true
      t.decimal :calculated_minimum_distance, precision: 3, scale: 1, default: 24.0, null: false, index: true
      t.decimal :calculated_maximum_distance, precision: 3, scale: 1, default: 5.0, null: false, index: true
      t.boolean :runs_on_dirt, default: true, null: false
      t.boolean :runs_on_turf, default: true, null: false
      t.boolean :trains_on_dirt, default: true, null: false
      t.boolean :trains_on_turf, default: true, null: false
      t.boolean :trains_on_jumps, default: false, null: false
      t.references :first_jockey, type: :bigint, index: true, foreign_key: { to_table: :jockeys }
      t.references :second_jockey, type: :bigint, index: true, foreign_key: { to_table: :jockeys }
      t.references :third_jockey, type: :bigint, index: true, foreign_key: { to_table: :jockeys }
      t.enum :racing_style, enum_type: "racing_style", comment: racing_styles.join(","), index: true
      t.integer :equipment, default: 0, null: false
      t.text :note_for_next_race
      t.datetime :next_race_note_created_at, index: true

      t.timestamps
    end
  end
end

