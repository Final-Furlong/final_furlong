class CreateBreedersSeriesNominations < ActiveRecord::Migration[8.1]
  def change
    series = %w[
      2yo_dirt
      2yo_filly_dirt
      2yo_turf
      2yo_filly_turf
      3yo_dirt
      3yo_filly_dirt
      3yo_turf
      3yo_filly_turf
      4yo_dirt
      4yo_mare_dirt
      4yo_turf
      4yo_mare_turf
      steeplechase
      steeplechase_filly
    ]
    create_enum :breeders_series_types, series

    create_table :breeders_series_nominations do |t|
      t.references :stable, type: :bigint, null: false, index: false, foreign_key: { to_table: :stables }
      t.enum :series_type, enum_type: :breeders_series_types, index: true, comment: series.join(",")
      t.integer :year, default: 0, null: false, index: true

      t.timestamps
    end

    add_index :breeders_series_nominations, %i[stable_id series_type year], unique: true
  end
end

