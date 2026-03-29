class AddNextRaceToRacehorseMetadata < ActiveRecord::Migration[8.1]
  def change
    add_column :racehorse_metadata, :next_entry_date, :date
    add_index :racehorse_metadata, :next_entry_date
  end
end

