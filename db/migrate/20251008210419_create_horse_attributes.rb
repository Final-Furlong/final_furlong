class CreateHorseAttributes < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    create_table :horse_attributes, id: :uuid do |t|
      t.references :horse, type: :uuid, null: false, foreign_key: { to_table: :horses }
      t.integer :age, default: 0

      t.timestamps
    end

    remove_index :horse_attributes, :horse_id if index_exists?(:horse_attributes, :horse_id)
    add_index :horse_attributes, :horse_id, unique: true, algorithm: :concurrently
  end
end

