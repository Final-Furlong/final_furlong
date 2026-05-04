class UpdateRacehorseStatsJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    racetrack = Racing::Racetrack.find_by(name: "Churchill Downs")
    Account::Stable.where(racetrack: nil).update_all(racetrack_id: racetrack.id) # rubocop:disable Rails/SkipsModelValidations
    new_horses = 0
    updated_horses = 0
    step :process_locations do |step|
      Horses::Horse.racehorse.where.associated(:race_metadata).find_each(start: step.cursor) do |horse|
        migrate_location(horse:)
        updated_horses += 1
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
    store_job_info(outcome: { new_horses:, updated_horses:, deleted: })
  end

  private

  def migrate_location(horse:)
    data = horse.race_metadata
    name = if data.at_home?
      horse.manager.name
    else
      racetrack_name = Racing::Racetrack.where(location: data.location).pick(:name)
      if horse.current_boarding.present?
        I18n.t("horse.location.at_boarding_farm", name: racetrack_name)
      else
        I18n.t("horse.location.at_racetrack", name: racetrack_name)
      end
    end
    data.update(location_string: name)
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

