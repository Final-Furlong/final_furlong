class CreateBroodmareFoalRecord < ActiveRecord::Migration[8.1]
  def change
    breed_rankings = %w[bronze silver gold platinum]
    create_enum :breed_rankings, breed_rankings

    create_table :broodmare_foal_records, id: :uuid do |t|
      t.references :horse, type: :uuid, null: false, index: true, foreign_key: { to_table: :horses }
      t.integer :born_foals_count, default: 0, null: false, index: true
      t.integer :stillborn_foals_count, default: 0, null: false
      t.integer :unborn_foals_count, default: 0, null: false, index: true
      t.integer :raced_foals_count, default: 0, null: false, index: true
      t.integer :winning_foals_count, default: 0, null: false, index: true
      t.integer :stakes_winning_foals_count, default: 0, null: false, index: true
      t.integer :multi_stakes_winning_foals_count, default: 0, null: false, index: true
      t.integer :millionaire_foals_count, default: 0, null: false, index: true
      t.integer :multi_millionaire_foals_count, default: 0, null: false, index: true
      t.integer :total_foal_points, default: 0, null: false
      t.integer :total_foal_races, default: 0, null: false
      t.bigint :total_foal_earnings, default: 0, null: false
      t.enum :breed_ranking, enum_type: "breed_rankings", index: true, comment: breed_rankings.join(", ")

      t.timestamps
    end
  end
end

