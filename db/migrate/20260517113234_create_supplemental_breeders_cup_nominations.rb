class CreateSupplementalBreedersCupNominations < ActiveRecord::Migration[8.1]
  def change
    create_table :supplemental_breeders_cup_nominations do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.references :race, type: :bigint, null: false, index: false, foreign_key: { to_table: :race_schedules }
      t.integer :year, default: 0, null: false, index: true

      t.timestamps
    end

    add_index :supplemental_breeders_cup_nominations, %i[horse_id year], unique: true
    add_index :supplemental_breeders_cup_nominations, %i[horse_id race_id]
  end
end

