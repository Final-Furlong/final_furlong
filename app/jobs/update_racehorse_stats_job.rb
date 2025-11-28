class UpdateRacehorseStatsJob < ApplicationJob
  queue_as :low_priority

  def perform
    racetrack = Racing::Racetrack.find_by(name: "Churchill Downs")
    Account::Stable.where(racetrack: nil).update_all(racetrack_id: racetrack.id) # rubocop:disable Rails/SkipsModelValidations
    horses = 0
    Horses::Horse.racehorse.find_each do |horse|
      migrate_stats(horse:)
      horses += 1
    end
    store_job_info(outcome: { horses: })
  end

  private

  def migrate_stats(horse:)
    data = horse.race_metadata || horse.build_race_metadata
    stable = horse.manager
    legacy_horse = Legacy::Horse.find(horse.legacy_id)
    last_raced_at = Racing::RaceResult.joins(:horses).where(race_result_horses: { horse_id: horse.id })
      .maximum(:date)
    last_boarded_at = if Horses::Boarding.current.exists?(horse_id: horse.id)
      Date.current
    else
      Horses::Boarding.ended.where(horse_id: horse.id).maximum(:end_date)
    end
    last_shipped_at = Shipping::RacehorseShipment.where(horse_id: horse.id).maximum(:arrival_date)
    last_shipped_home_at = Shipping::RacehorseShipment.where(horse_id: horse.id, shipping_type: "track_to_farm").maximum(:arrival_date)
    # count rest days since last race
    rest_days = 0
    Horses::Boarding.where(horse_id: horse.id).where("start_date > ?", last_raced_at).find_each do |boarding|
      rest_days += boarding.days
      if boarding.current?
        rest_days += (Date.current - boarding.start_date).to_i
      end
    end
    if last_raced_at && last_shipped_home_at && last_shipped_home_at > last_raced_at
      Shipping::RacehorseShipment.where(horse_id: horse.id, shipping_type: "track_to_farm").where("departure_date > ?", last_raced_at).order(departure_date: :asc).find_each do |farm_shipment|
        departure = Shipping::RacehorseShipment.where(horse_id: horse.id, shipping_type: "farm_to_track").where("departure_date > ?", farm_shipment.arrival_date).order(departure_date: :asc).first
        rest_days += if departure
          (departure.departure_date - farm_shipment.arrival_date).to_i
        else
          (Date.current - farm_shipment.arrival_date).to_i
        end
      end
    end
    workouts_since_last_race = Racing::Workout.where(horse_id: horse.id).where("date > ?", last_raced_at).count
    last_rested_at = [last_boarded_at, last_shipped_home_at].compact.max
    last_rested_at ||= Date.current
    racetrack = if legacy_horse.Location == 59
      stable.racetrack
    else
      legacy_racetrack = Legacy::Racetrack.find_by(ID: legacy_horse.Location)
      return stable.racetrack unless legacy_racetrack

      Racing::Racetrack.find_by(name: legacy_racetrack.Name)
    end
    racetrack ||= stable.racetrack
    attrs = {
      last_raced_at:,
      last_rested_at:,
      last_shipped_at:,
      rest_days_since_last_race: rest_days,
      workouts_since_last_race:,
      energy_grade: legacy_horse.DisplayEnergy,
      fitness_grade: legacy_horse.DisplayFitness,
      racetrack:,
      at_home: legacy_horse.Location == 59,
      in_transit: horse.racing_shipments.current.exists?
    }
    data.update!(attrs)
  end
end

