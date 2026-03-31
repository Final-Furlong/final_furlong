class AddScheduledFieldsToShipments < ActiveRecord::Migration[8.1]
  def change
    add_column :racehorse_shipments, :scheduled, :boolean, default: false, null: false
    add_column :broodmare_shipments, :scheduled, :boolean, default: false, null: false
    add_index :racehorse_shipments, :scheduled
    add_index :broodmare_shipments, :scheduled
  end
end

