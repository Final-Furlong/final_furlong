class AddRaceResultAbbreviationToRacehorseMetadata < ActiveRecord::Migration[8.1]
  def change
    add_column :racehorse_metadata, :latest_result_abbreviation, :string
  end
end

