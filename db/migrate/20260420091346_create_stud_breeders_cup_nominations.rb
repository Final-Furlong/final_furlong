class CreateStudBreedersCupNominations < ActiveRecord::Migration[8.1]
  def change
    create_table :stud_breeders_cup_nominations do |t|
      t.references :stud, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.integer :year, null: false, index: true

      t.timestamps
    end

    add_index :stud_breeders_cup_nominations, %i[stud_id year], unique: true
  end
end

