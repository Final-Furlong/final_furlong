class MigrateLegacyFutureEventsService
  def call
    Legacy::FutureEvent.find_each do |legacy_event|
      horse = Horses::Horse.find_by(legacy_id: legacy_event.Horse)
      date = legacy_event.Date - 4.years
      next if date < Date.current
      event_type = case legacy_event.Event
      when "Nominate"
        "nominate"
      when "Death"
        "die"
      end
      future_event = Horses::FutureEvent.find_or_initialize_by(horse:, event_type:)
      future_event.date = date
      future_event.save!
    end
    Legacy::Horse.where("Status NOT IN (2, 4, 5, 6) AND Gender != :gender AND (Retire > :date OR Die > :date)", { gender: "G", date: Date.current + 4.years }).find_each do |legacy_horse|
      horse = Horses::Horse.find_by(legacy_id: legacy_horse.ID)
      date = legacy_horse.Retire - 4.years
      if date > Date.current
        event_type = "retire"
        future_event = Horses::FutureEvent.find_or_initialize_by(horse:, event_type:)
        future_event.date = date
        future_event.save!
      end
      date = legacy_horse.Die - 4.years
      if date > Date.current
        event_type = "die"
        future_event = Horses::FutureEvent.find_or_initialize_by(horse:, event_type:)
        if future_event.persisted?
          future_event.date = date if date > future_event.date
        else
          future_event.date = date
        end
        future_event.save!
      end
    end
  end
end

