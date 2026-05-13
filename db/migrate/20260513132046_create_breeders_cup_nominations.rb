class CreateBreedersCupNominations < ActiveRecord::Migration[8.1]
  def change
    create_table :breeders_cup_nominations do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.integer :effective_year, index: true

      t.timestamps
    end

    add_index :breeders_cup_nominations, :horse_id, unique: true
  end
end

