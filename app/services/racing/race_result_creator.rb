module Racing
  class RaceResultCreator
    def create_result(date:, number:, race_type:, distance:, age:, surface:, condition:, time:, purse:, horses:,
      grade: nil, name: nil, claiming_price: nil, male_only: false, female_only: false)
      race_date = Date.parse(date.to_s)
      race_result = Racing::RaceResult.find_or_initialize_by(date: race_date, number:)
      result = Result.new(race_result:)
      ActiveRecord::Base.transaction do
        attrs = {
          age:,
          distance:,
          male_only:,
          female_only:,
          race_type:,
          grade:,
          name:,
          purse:,
          claiming_price:,
          track_surface: surface,
          condition:,
          split: "2F",
          time_in_seconds: time,
          created_at: race_date.beginning_of_day + number.minutes
        }
        race_result.update!(attrs)

        if race_result.persisted?
          race_horses = process_race_horses(race_result:, horses:)
          race_horses.each do |race_horse|
            result.created = race_horse.valid?
            stats = update_stats(horse: race_horse.horse, race_horse:, horses:, date: race_date, racetrack: surface.racetrack)
            next if race_horse.save! && (stats.blank? || stats.save!)

            result.created = false
            raise ActiveRecord::Rollback, race_horse.errors.full_messages.to_sentence
          end
        end
        trigger_horse_attribute_updates(horses:)
        if max_race?(date:, number:)
          Racing::RaceResultHorse.counter_culture_fix_counts
          Racing::RaceRecord.refresh
          Racing::LifetimeRaceRecord.refresh
          UpdateRaceResultHorseAbbreviationsJob.perform_later(date:)
          Racing::RaceDayUpdaterJob.perform_later(date:)
          Daily::ProcessFutureShipmentsJob.perform_later
          User::SendDeveloperNotifications.call(title: "FF Races Finished", message: "Races finished running!")
        end
        return result
      rescue => e
        race_result.destroy if race_result.persisted?
        result.created = false
        result.error = e.message
        return result
      end
    end

    class Result
      attr_accessor :race_result, :created, :error

      def initialize(race_result:, created: false, error: nil)
        @race_result = race_result
        @created = created
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def max_race?(date:, number:)
      number == Racing::RaceSchedule.where(date:).maximum(:number)
    end

    def trigger_horse_attribute_updates(horses:)
      horses.each do |horse_hash|
        horse = Horses::Horse.find_by(legacy_id: horse_hash[:legacy_id])
        next unless horse
        next if horse_hash[:finish_position] > 5 && !horse.horse_attributes

        Horses::UpdateHorseAttributesJob.perform_later(horse)
      end
    end

    def update_stats(horse:, horses:, race_horse:, date:, racetrack:)
      stats = horse.racing_stats
      return unless stats

      finish = horses.find { |hash| hash[:legacy_id] == horse.legacy_id }
      stats.energy -= finish[:energy_used]
      stats.energy = Config::Racing.minimum_energy if stats.energy < Config::Racing.minimum_energy
      stats.fitness += finish[:fitness_gained]
      stats.fitness = Config::Racing.maximum_fitness if stats.fitness > Config::Racing.maximum_fitness
      stats.xp_current += finish[:experience_gained]
      stats.xp_current = Config::Racing.maximum_xp if stats.xp_current > Config::Racing.maximum_xp
      stats.natural_energy_current -= [10, finish[:natural_energy_used]].min
      if (data = horse.race_metadata)
        data.update_grades(energy: stats.energy, fitness: stats.fitness, update_legacy: true)
        next_entry_date = horse.race_entries.where("date > ?", date).minimum(:date) || horse.future_race_entries.where("date > ?", date).minimum(:date)
        data.update(last_raced_at: date, next_entry_date:, racetrack:, location: racetrack.location)
      end
      stats
    end

    def calculate_earnings(purse, finish_position)
      return 0 unless Config::Racing.purses[finish_position - 1]

      (purse * Config::Racing.purses[finish_position - 1]).to_i
    end

    def calculate_points(finish, race_result)
      if race_result.stakes?
        Config::Racing.points[:stakes][finish - 1]
      elsif race_result.allowance?
        Config::Racing.points[:allowance][finish - 1]
      elsif race_result.claiming?
        Config::Racing.points[:claiming][finish - 1]
      elsif race_result.maiden?
        Config::Racing.points[:maiden][finish - 1]
      end
    end

    def process_race_horses(race_result:, horses:)
      race_horses = []
      horses.each do |horse|
        race_horse = Racing::RaceResultHorse.find_or_initialize_by(race: race_result, legacy_horse_id: horse[:legacy_id])
        horse_class = Horses::Horse.find_by(legacy_id: horse[:legacy_id])
        entry = Racing::RaceEntry.joins(:race).where(race: { number: race_result.number, date: race_result.date }).find_by(horse: horse_class)
        attrs = {
          horse: horse_class,
          stable: horse_class.manager,
          post_parade: horse[:post_parade],
          positions: horse[:positions],
          margins: horse[:margins],
          fractions: horse[:fractions],
          speed_factor: horse[:speed_factor],
          finish_position: horse[:finish_position],
          weight: entry.weight,
          jockey: entry.jockey,
          odd: entry.odd,
          blinkers: entry.blinkers,
          shadow_roll: entry.shadow_roll,
          wraps: entry.wraps,
          figure_8: entry.figure_8,
          no_whip: entry.no_whip,
          created_at: race_result.date.beginning_of_day + race_result.number.minutes + horse[:post_parade].minutes,
          earnings: calculate_earnings(race_result.purse, horse[:finish_position]),
          points: calculate_points(race_horse.finish_position, race_result)
        }
        race_horse.assign_attributes(attrs)
        race_horses << race_horse
      end
      race_horses
    end
  end
end

