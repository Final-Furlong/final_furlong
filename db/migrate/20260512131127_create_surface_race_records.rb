class CreateSurfaceRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :surface_race_records unless view_exists?(:surface_race_records)
  end
end

