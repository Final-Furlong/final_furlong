class CreateBreedingStats < ActiveRecord::Migration[8.1]
  def change
    create_table :breeding_stats do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.integer :breeding_potential, null: false, default: 0
      t.integer :breeding_potential_grandparent, null: false, default: 0
      t.integer :soundness, null: false, default: 0
      t.string :dosage, index: true

      t.timestamps
    end

    add_index :breeding_stats, :horse_id, unique: true
  end
end

