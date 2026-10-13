class CreateBreedersSeriesPotentialEntry < ActiveRecord::Migration[8.1]
  def change
    create_table :breeders_series_potential_entries do |t|
      t.references :horse, null: false, index: false, foreign_key: { to_table: :horses }
      t.references :stable, null: false, index: true, foreign_key: { to_table: :stables }
      t.string :record, null: false
      t.integer :rank, null: false, index: true, default: 0
      t.references :first_race, index: true, foreign_key: { to_table: :race_schedules }
      t.references :second_race, index: true, foreign_key: { to_table: :race_schedules }
      t.references :third_race, index: true, foreign_key: { to_table: :race_schedules }

      t.timestamps
    end

    add_index :breeders_series_potential_entries, %i[horse_id first_race_id], unique: true
  end
end

