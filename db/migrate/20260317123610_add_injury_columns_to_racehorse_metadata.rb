class AddInjuryColumnsToRacehorseMetadata < ActiveRecord::Migration[8.1]
  def change
    add_column :racehorse_metadata, :last_injured_at, :date
    add_column :racehorse_metadata, :currently_injured, :boolean, null: false, default: false

    add_index :racehorse_metadata, :currently_injured
    add_index :racehorse_metadata, :last_injured_at
  end
end

