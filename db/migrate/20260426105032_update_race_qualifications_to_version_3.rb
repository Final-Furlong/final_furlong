class UpdateRaceQualificationsToVersion3 < ActiveRecord::Migration[8.1]
  def change
    update_view :race_qualifications,
      version: 3,
      revert_to_version: 2,
      materialized: { side_by_side: true }
  end
end

