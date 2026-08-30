class UpdateBreedersCupSprintQualifiersToVersion3 < ActiveRecord::Migration[8.1]
  def change
    update_view :breeders_cup_sprint_qualifiers,
      version: 3,
      revert_to_version: 2,
      materialized: { side_by_side: true }
  end
end

