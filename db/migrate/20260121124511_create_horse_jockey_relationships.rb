class CreateHorseJockeyRelationships < ActiveRecord::Migration[8.1]
  def change
    create_table :horse_jockey_relationships do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.references :jockey, type: :bigint, null: false, index: false, foreign_key: { to_table: :jockeys }
      t.integer :experience, type: :integer, null: false, default: 0
      t.integer :happiness, type: :integer, null: false, default: 0
      t.timestamps
    end
    add_index :horse_jockey_relationships, %i[horse_id jockey_id], unique: true
  end
end

