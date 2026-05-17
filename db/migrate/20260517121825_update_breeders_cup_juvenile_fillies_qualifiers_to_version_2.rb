class UpdateBreedersCupJuvenileFilliesQualifiersToVersion2 < ActiveRecord::Migration[8.1]
  def change
    update_view :breeders_cup_juvenile_fillies_qualifiers, version: 2, revert_to_version: 1
  end
end

