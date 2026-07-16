class UpdateStudFoalRecordsToVersion2 < ActiveRecord::Migration[8.1]
  def change
    update_view :stud_foal_records,
      version: 2,
      revert_to_version: 1,
      materialized: { side_by_side: true }
  end
end

