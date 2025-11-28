class CreateRaceEntries < ActiveRecord::Migration[8.1]
  def change
    racing_styles = %w[leading off_pace midpack closing]

    create_table :race_entries do |t|
      t.references :race, type: :bigint, null: false, index: true, foreign_key: { to_table: :race_schedules }
      t.date :date, null: false, index: true
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.integer :equipment, default: 0, null: false, index: true
      t.integer :post_parade, default: 0, null: false, index: true
      t.references :jockey, type: :bigint, foreign_key: { to_table: :jockeys }
      t.references :first_jockey, type: :bigint, foreign_key: { to_table: :jockeys }
      t.references :second_jockey, type: :bigint, foreign_key: { to_table: :jockeys }
      t.references :third_jockey, type: :bigint, foreign_key: { to_table: :jockeys }
      t.enum :racing_style, enum_type: "racing_style", comment: racing_styles.join(","), index: true
      t.references :odd, type: :bigint, index: false, foreign_key: { to_table: :race_odds }
      t.integer :weight, default: 0, null: false

      t.timestamps
    end
    remove_index :race_entries, column: :horse_id, if_exists: true
    add_index :race_entries, %i[horse_id date], unique: true

    shipping_modes = %w[road air]

    create_table :future_race_entries do |t|
      t.references :race, type: :bigint, null: false, index: true, foreign_key: { to_table: :race_schedules }
      t.date :date, null: false, index: true
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.integer :equipment, default: 0, null: false, index: true
      t.references :first_jockey, type: :bigint, foreign_key: { to_table: :jockeys }
      t.references :second_jockey, type: :bigint, foreign_key: { to_table: :jockeys }
      t.references :third_jockey, type: :bigint, foreign_key: { to_table: :jockeys }
      t.enum :racing_style, enum_type: "racing_style", comment: racing_styles.join(","), index: true
      t.boolean :auto_enter, default: false, null: false, index: true
      t.boolean :auto_ship, default: false, null: false, index: true
      t.enum :ship_mode, enum_type: :shipping_mode, index: true, comment: shipping_modes.join(", ")
      t.boolean :ship_when_entries_open, default: false, null: false, index: true
      t.boolean :ship_when_horse_is_entered, default: false, null: false, index: true
      t.boolean :ship_only_if_horse_is_entered, default: false, null: false, index: true
      t.date :ship_date, index: true

      t.timestamps
    end
    remove_index :future_race_entries, column: :horse_id, if_exists: true
    add_index :future_race_entries, %i[horse_id date], unique: true
  end
end

