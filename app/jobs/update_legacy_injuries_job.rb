class UpdateLegacyInjuriesJob < ApplicationJob
  queue_as :low_priority

  def perform
    min_date = Horses::HistoricalInjury.where(date: ..."2026-03-03").maximum(:date) || Date.current - 30.years
    Legacy::HorseInjury.where(Date: (min_date + 4.years)..).find_each do |legacy_injury|
      migrate_legacy_injury(legacy_injury:)
    end
  end

  private

  def migrate_legacy_injury(legacy_injury:)
    horse = Horses::Horse.find_by(legacy_id: legacy_injury.Horse)
    return unless horse

    date = legacy_injury.Date - 4.years
    injury = Horses::HistoricalInjury.find_or_initialize_by(horse:, date:)
    injury.leg = legacy_injury.Leg if legacy_injury.Leg.present?
    injury.injury_type = case legacy_injury.Injury
    when 1
      "heat"
    when 2
      "swelling"
    when 3
      "cut"
    when 4
      "limping"
    when 5
      "overheat"
    when 6
      "bowed tendon"
    when 7
      "broken leg"
    when 8
      "heart attack"
    end
    injury.save!
  end
end

