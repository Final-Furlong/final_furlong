class CreateHorseSalesHistory < ActiveRecord::Migration[8.1]
  def change
    create_table :horse_sales do |t|
      t.references :horse, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }
      t.date :date, null: false, index: true
      t.references :seller, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.references :buyer, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.integer :price, default: 0, null: false
      t.boolean :private, default: true, null: false

      t.timestamps
    end
  end
end

