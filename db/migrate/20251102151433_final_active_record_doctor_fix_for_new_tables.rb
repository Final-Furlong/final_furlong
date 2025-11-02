class FinalActiveRecordDoctorFixForNewTables < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      # rubocop:disable Rails/ReversibleMigration
      change_column :horses, :location_bred_id, :bigint
      # rubocop:enable Rails/ReversibleMigration
    end
  end
end
