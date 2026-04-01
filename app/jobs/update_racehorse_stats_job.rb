class UpdateRacehorseStatsJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    racetrack = Racing::Racetrack.find_by(name: "Churchill Downs")
    Account::Stable.where(racetrack: nil).update_all(racetrack_id: racetrack.id) # rubocop:disable Rails/SkipsModelValidations
    horses = 0
    step :process do |step|
      Horses::Horse.racehorse.where.missing(:race_metadata).find_each(start: step.cursor) do |horse|
        migrate_stats(horse:)
        horses += 1
        step.advance! from: horse.id
      end
    end
    deleted = 0
    step :cleanup do |step|
      Horses::Horse.where.not(status: "racehorse").where.associated(:race_metadata).find_each(start: step.cursor) do |horse|
        Racing::RacehorseMetadata.where(horse:).first&.destroy
        deleted += 1
        step.advance! from: horse.id
      end
    end
    store_job_info(outcome: { horses:, deleted: })
  end

  private

  def migrate_stats(horse:)
    data = horse.race_metadata || horse.build_race_metadata
    attrs = {}
    stable = horse.manager
    legacy_horse = Legacy::Horse.find(horse.legacy_id)
    last_raced_at = Racing::RaceResult.joins(:horses).where(race_result_horses: { horse_id: horse.id })
      .maximum(:date)
    if data.last_raced_at.blank? || data.last_raced_at < last_raced_at
      attrs[:last_raced_at] = last_raced_at
      attrs[:latest_result_abbreviation] = Racing::RaceResultHorse.joins(:race).where(race: { date: last_raced_at }, horse:).first&.result_abbreviation
    end
    last_boarded_at = if Horses::Boarding.current.exists?(horse_id: horse.id)
      Date.current
    else
      Horses::Boarding.ended.where(horse_id: horse.id).maximum(:end_date)
    end
    last_injured_at = Horses::HistoricalInjury.where(horse:).maximum(:date)
    currently_injured = horse.current_injuries.present?
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
    workouts_since_last_race = Workouts::Workout.where(horse_id: horse.id).where("date > ?", last_raced_at).count
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
    energy_grade, fitness_grade = pick_grades(horse, legacy_horse.DisplayEnergy, legacy_horse.EnergyCurrent, legacy_horse.DisplayFitness, legacy_horse.Fitness)
    attrs.merge!(
      last_rested_at:,
      last_shipped_at:,
      last_injured_at:,
      currently_injured:,
      rest_days_since_last_race: rest_days,
      workouts_since_last_race:,
      racetrack:,
      location: racetrack.location,
      location_string: location_name(horse),
      at_home: legacy_horse.Location == 59,
      in_transit: horse.racing_shipments.current.exists?
    )
    unless data.persisted?
      attrs[:energy_grade] = energy_grade
      attrs[:fitness_grade] = fitness_grade
    end
    data.update!(attrs)
  end

  def location_name(horse)
    last_shipment = Shipping::RacehorseShipment.where(horse_id: horse.id).order(departure_date: :desc).first
    return horse.manager.name if last_shipment.blank?

    case last_shipment.shipping_type
    when "track_to_track", "farm_to_track"
      name = Racing::Racetrack.where(location: last_shipment.ending_location).pick(:name)
      if horse.current_boarding.present?
        I18n.t("horse.location.at_boarding_farm", name:)
      else
        I18n.t("horse.location.at_racetrack", name:)
      end
    when "track_to_farm"
      horse.manager.name
    end
  end

  def pick_grades(horse, energy_grade, energy, fitness_grade, fitness)
    egrade = energy_grade.upcase if Config::Racing.letter_grades.map(&:upcase).include?(energy_grade&.upcase)
    fgrade = fitness_grade.upcase if Config::Racing.letter_grades.map(&:upcase).include?(fitness_grade&.upcase)
    return [egrade, fgrade] unless egrade.blank? || fgrade.blank?

    egrade, fgrade = horse.race_metadata.update_grades(energy:, fitness:)
    [egrade, fgrade]
  end
end

