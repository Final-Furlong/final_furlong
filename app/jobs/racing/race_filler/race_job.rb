class Racing::RaceFiller::RaceJob < ApplicationJob
  queue_as :latency_5m

  def perform(id:)
    race = Racing::RaceSchedule.includes(:track_surface).find_by(id:)
    horses_needed = Config::Racing.minimum_horses - race.entries_count
    process_race(Config::Racing.minimum_horses, horses_needed, race, owner)
  end

  private

  def process_race(total_horses_needed, horses_needed, race, owner)
    query = Horses::Horse.racehorse.joins(:race_options, :race_metadata, :race_qualification, :racing_stats)
      .managed_by(owner).where.missing(:race_entries).where.missing(:future_race_entries).merge(Racing::RacingStats.min_energy(Config::Racing.minimum_energy_racefiller))
    if owner.name != Config::Game.stable || race.race_type != "claiming"
      query = query.merge(Racing::RaceQualification.qualified_for_exactly(race.race_type))
    end
    query = query.min_age(race.min_age).max_age(race.max_age)
    query = query.female if race.female_only
    query = query.not_female if race.male_only
    if owner.name != Config::Game.stable
      query = query.merge(Racing::RaceOption.distance_matching(distance)).merge(Racing::RaceOption.send(surface_name.to_sym))
    end
    surface_type = race.race_surface_type.inquiry
    if surface_type.flat?
      query = query.merge(Racing::RaceOption.send(surface_type.to_sym))
    end
    query = query.order("race_metadata.last_raced_at DESC")
    query = query.limit(100)
    query.each do |horse|
      if horses_needed > 0
        result = Racing::GameEntryCreator.new.create_entry(race:, horse:)
        if result.created?
          horses_needed -= 1
          Racing::RaceEntry.counter_culture_fix_counts
          horses_needed = total_horses_needed - race.reload.entries_count
        end
      else
        next
      end
    end
  end
end

