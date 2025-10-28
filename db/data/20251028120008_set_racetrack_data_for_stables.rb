class SetRacetrackDataForStables < ActiveRecord::Migration[8.0]
  def up
    Account::Stable.where.missing(:racetrack).find_each do |stable|
      legacy_stable = Legacy::User.find(stable.legacy_id)

      legacy_racetrack = Legacy::Racetrack.find_by(ID: legacy_stable.TrackID)
      next unless legacy_racetrack

      racetrack = Racing::Racetrack.find_by(name: legacy_racetrack.Name)
      next unless racetrack

      stable.update(racetrack:, miles_from_track: legacy_stable.TrackMiles)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

