class CreateShipmentRoutes < ActiveRecord::Migration[8.1]
  def change
    create_table :shipment_routes do |t|
      t.references :starting_location, type: :bigint, null: false, index: true, foreign_key: { to_table: :locations }
      t.references :ending_location, type: :bigint, null: false, index: true, foreign_key: { to_table: :locations }
      t.integer :miles, default: 0, null: false
      t.integer :road_days, index: true
      t.integer :road_cost
      t.integer :air_days, index: true
      t.integer :air_cost

      t.timestamps
    end
    remove_index :shipment_routes, :starting_location_id, if_exists: true
    add_index :shipment_routes, %i[starting_location_id ending_location_id], unique: true
  end
end

