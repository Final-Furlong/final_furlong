class CreateBreedersCupPotentialEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :breeders_cup_potential_entries do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.references :stable, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.references :race, type: :bigint, null: false, index: true, foreign_key: { to_table: :race_schedules }
      t.string :record, null: false
      t.integer :rank, null: false, default: 0, index: true

      t.timestamps
    end

    add_index :breeders_cup_potential_entries, %i[horse_id race_id], unique: true
  end
end

