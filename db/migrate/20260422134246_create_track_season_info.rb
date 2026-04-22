class CreateTrackSeasonInfo < ActiveRecord::Migration[8.1]
  def change
    seasons = %w[winter spring summer fall]
    create_enum :season_list, seasons

    create_table :track_season_info do |t|
      t.references :location, type: :bigint, null: false, index: false, foreign_key: { to_table: :locations }
      t.enum :season, enum_type: :season_list, null: false
      t.integer :fast_chance, default: 0, null: 0
      t.integer :good_chance, default: 0, null: 0
      t.integer :wet_chance, default: 0, null: 0
      t.integer :slow_chance, default: 0, null: 0

      t.timestamps
    end

    add_index :track_season_info, %i[location_id season], unique: true
  end
end

