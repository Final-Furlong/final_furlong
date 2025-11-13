class CreateStudFoalRecord < ActiveRecord::Migration[8.1]
  def change
    create_table :stud_foal_records do |t|
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.integer :born_foals_count, default: 0, null: false, index: 0
      t.integer :raced_foals_count, default: 0, null: false
      t.integer :winning_foals_count, default: 0, null: false
      t.integer :stakes_winning_foals_count, default: 0, null: false
      t.integer :multi_stakes_winning_foals_count, default: 0, null: false
      t.integer :millionaire_foals_count, default: 0, null: false
      t.integer :multi_millionaire_foals_count, default: 0, null: false
      t.bigint :total_foal_earnings, default: 0, null: false
      t.integer :total_foal_points, default: 0, null: false
      t.integer :total_foal_races, default: 0, null: false
      t.string :breed_ranking
      t.integer :unborn_foals_count, default: 0, null: false
      t.integer :stillborn_foals_count, default: 0, null: false
      t.integer :crops_count, default: 0, null: false

      t.timestamps
    end
  end
end

