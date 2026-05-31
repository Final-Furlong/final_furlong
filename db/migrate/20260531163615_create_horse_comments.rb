class CreateHorseComments < ActiveRecord::Migration[8.1]
  def change
    create_table :horse_comments do |t|
      t.references :horse, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }
      t.references :stable, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.text :comment, null: false
      t.boolean :private, null: false, default: true, index: true

      t.timestamps
    end
  end
end

