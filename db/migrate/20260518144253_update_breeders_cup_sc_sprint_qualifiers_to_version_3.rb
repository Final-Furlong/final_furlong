class UpdateBreedersCupScSprintQualifiersToVersion3 < ActiveRecord::Migration[8.1]
  def change
    update_view :breeders_cup_sc_sprint_qualifiers, version: 3, revert_to_version: 2
  end
end

