class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :name, null: false
      t.string :state
      t.string :county
      t.string :country, null: false

      t.timestamps
    end

    safety_assured do
      remove_foreign_key :horses, :racetracks, column: :location_bred_id

      remove_column :racetracks, :state, :string
      remove_column :racetracks, :country, :string
      add_reference :racetracks, :location, type: :uuid, index: true, foreign_key: true

      remove_column :horses, :location_bred_id, :uuid
      add_reference :horses, :location_bred, type: :uuid, index: true, foreign_key: { to_table: :locations }
    end
  end
end
