class UpdateBreedersCupClassicQualifiersToVersion4 < ActiveRecord::Migration[8.1]
  def change
    update_view :breeders_cup_classic_qualifiers,
      version: 4,
      revert_to_version: 3,
      materialized: { side_by_side: true }
  end
end

