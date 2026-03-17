class AddLocationFieldsToRacehorseMetadata < ActiveRecord::Migration[8.1]
  def change
    add_reference :racehorse_metadata, :location, type: :bigint, index: true, foreign_key: { to_table: :locations }
    add_column :racehorse_metadata, :location_string, :string, null: false, default: "Farm"
  end
end

