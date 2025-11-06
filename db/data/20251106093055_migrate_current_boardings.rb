class MigrateCurrentBoardings < ActiveRecord::Migration[8.1]
  def up
    query = Legacy::Boarding.includes(:farm).where(end_date: nil)
    query = query.or(Legacy::Boarding.includes(:farm).where(end_date: "2029-01-01"..))
    query.find_each do |legacy_boarding|
      legacy_racetrack = Legacy::Racetrack.find_by(ID: legacy_boarding.farm.track_id)
      location = Location.joins(:racetrack).find_by(racetracks: { name: legacy_racetrack.Name })
      horse = Horses::Horse.find_by(legacy_id: legacy_boarding.horse_id)
      next unless horse

      boarding = Horses::Boarding.new(horse:, location:, start_date: legacy_boarding.start_date - 4.years)
      if legacy_boarding.end_date.present?
        boarding.end_date = legacy_boarding.end_date - 4.years
        boarding.days = (boarding.end_date - boarding.start_date).to_i
      end
      boarding.save(validate: false)
    end
  end

  def down
    Account::Boarding.delete_all
  end
end

