class CreateRaceSeriesWinners < ActiveRecord::Migration[8.1]
  def change
    create_table :race_series_winners do |t|
      t.references :series, type: :bigint, null: false, index: false, foreign_key: { to_table: :race_series }
      t.references :horse, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }
      t.integer :year, null: false, default: 0, index: true

      t.timestamps
    end

    add_index :race_series_winners, %i[series_id year], unique: true
  end
end

