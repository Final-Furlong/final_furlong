module Racing
  class InjuryUpdater
    def update_records(date:)
      injuries = 0
      Horses::HistoricalInjury.where(date:).find_each do |injury|
        horse = injury.horse
        next unless Racing::RaceResultHorse.by_date(date).exists?(horse:)

        horse.race_metadata&.update(last_injured_at: date, currently_injured: true)
        injuries += 1
      end
      injuries
    end
  end
end

