class CreateBoardings < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    create_table :boardings, id: :uuid do |t|
      t.references :horse, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }
      t.references :location, type: :bigint, null: false, index: true, foreign_key: { to_table: :locations }
      t.date :start_date, null: false, index: true
      t.date :end_date, index: true
      t.integer :days, default: 0, null: false

      t.timestamps
    end
    add_index :boardings, %i[horse_id location_id start_date], unique: true, algorithm: :concurrently
  end
end

