class CreateRacehorseShipping < ActiveRecord::Migration[8.1]
  def change
    shipping_modes = %w[road air]
    create_enum :shipping_mode, shipping_modes
    shipping_types = %w[track_to_track farm_to_track track_to_farm]
    create_enum :shipping_type, shipping_types

    create_table :racehorse_shipments do |t|
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.date :departure_date, null: false
      t.date :arrival_date, null: false, index: true
      t.enum :mode, enum_type: :shipping_mode, null: false, index: true, comment: shipping_modes.join(", ")
      t.references :starting_location, type: :bigint, null: false, index: true, foreign_key: { to_table: :locations }
      t.references :ending_location, type: :bigint, null: false, index: true, foreign_key: { to_table: :locations }
      t.enum :shipping_type, enum_type: :shipping_type, null: false, index: true, comment: shipping_types.join(", ")

      t.timestamps
    end
    remove_index :racehorse_shipments, column: :horse_id, if_exists: true
    add_index :racehorse_shipments, %i[horse_id departure_date], unique: true

    create_table :broodmare_shipments do |t|
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.date :departure_date, null: false
      t.date :arrival_date, null: false, index: true
      t.enum :mode, enum_type: :shipping_mode, null: false, index: true, comment: shipping_modes.join(", ")
      t.references :starting_farm, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.references :ending_farm, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }

      t.timestamps
    end
    remove_index :broodmare_shipments, column: :horse_id, if_exists: true
    add_index :broodmare_shipments, %i[horse_id departure_date], unique: true
  end
end

