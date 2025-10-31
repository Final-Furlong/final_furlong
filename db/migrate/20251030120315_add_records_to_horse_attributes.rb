class AddRecordsToHorseAttributes < ActiveRecord::Migration[8.1]
  def change
    add_column :horse_attributes, :track_record, :string, default: "Unraced", null: false
    add_column :horse_attributes, :title, :string
    add_column :horse_attributes, :breeding_record, :string, default: "None", null: false
    add_column :horse_attributes, :dosage_text, :string
  end
end

