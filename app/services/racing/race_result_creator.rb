module Racing
  class RaceResultCreator
    attr_reader :date, :race

    def create_result(race:, time:, horses:, injuries: [])
      @race = race
      @date = race.date
      race_result = Racing::RaceResult.find_or_initialize_by(date:, number: race.number)
      result = Result.new(race_result:)
      surface = race.track_surface
      ActiveRecord::Base.transaction do
        attrs = {
          age: race.age,
          distance: race.distance,
          male_only: race.male_only,
          female_only: race.female_only,
          race_type: race.race_type,
          grade: race.grade,
          name: race.name,
          purse: race.purse,
          claiming_price: race.claiming_price,
          track_surface: surface,
          condition: surface.condition,
          split: "2F",
          time_in_seconds: time,
          created_at: date.beginning_of_day + race.number.minutes
        }
        race_result.update!(attrs)

        if race_result.persisted?
          race_horses = process_race_horses(race_result:, horses:)
          process_injuries(injuries:)
          race_horses.each do |race_horse|
            result.created = race_horse.valid?
            stats = update_stats(horse: race_horse.horse, race_horse:, horses:, date:, racetrack: surface.racetrack)
            options = update_options(horse: race_horse.horse, surface:) if surface.surface == "steeplechase"
            relationship = update_jockey_relationship(horse: race_horse.horse, horses:)
            create_transactions(result: race_horse)
            result.created = race_horse.save! && relationship.save! && (options.blank? || options.save) && (stats.blank? || stats.save)
            next if result.created?

            raise ActiveRecord::Rollback, race_horse.errors.full_messages.to_sentence
          end
        end
        if result.created?
          Racing::RaceSeriesWinnerCheckJob.set(good_job_labels: [race.id], wait: 10.minutes).perform_later(race_id: race.id)
          if max_race?(number: race.number)
            Racing::RaceResultHorse.counter_culture_fix_counts
            Racing::RaceRecord.refresh
            Racing::LifetimeRaceRecord.refresh
            UpdateRaceResultHorseAbbreviationsJob.set(good_job_labels: [date]).perform_later(date:)
            Racing::RaceDayUpdaterJob.set(good_job_labels: [date]).perform_later(date:)
            Daily::ProcessFutureShipmentsJob.set(good_job_labels: [date]).perform_later(date:)
            User::SendDeveloperNotifications.call(title: "FF Races Finished", message: "Races finished running!")
          end
        end
        return result
      rescue => e
        race_result.destroy if race_result.persisted?
        result.created = false
        result.error = e.message
        Sentry.capture_exception(e)
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

    def max_race?(number:)
      number == Racing::RaceSchedule.where(date:).maximum(:number)
    end

    def create_transactions(result:)
      return if result.earnings.zero?

      horse = result.horse
      jockey = result.jockey
      Accounts::BudgetTransactionCreator.new.create_transaction(
        stable: result.stable,
        description: I18n.t("racing.race.budget_race_winnings", date: race.date, number: race.number, name: horse.name, position: result.finish_position.ordinalize),
        amount: result.earnings
      )
      jockey_fee = (result.earnings * Config::Racing[:"jockey_fee_#{jockey.status.downcase}_percent"]).floor
      return unless jockey_fee.positive?

      Accounts::BudgetTransactionCreator.new.create_transaction(
        stable: result.stable,
        description: I18n.t("racing.race.budget_race_jockey_fee", date: race.date, number: race.number, jockey: jockey.full_name, horse: horse.name),
        amount: jockey_fee * -1
      )
    end

    def update_options(horse:, surface:)
      options = horse.race_options
      return unless options

      attrs = { racehorse_type: "jump" }
      attrs[:first_jockey_id] = nil if Racing::Jockey.active.flat.exists?(id: options.first_jockey_id)
      attrs[:second_jockey_id] = nil if Racing::Jockey.active.flat.exists?(id: options.second_jockey_id)
      attrs[:third_jockey_id] = nil if Racing::Jockey.active.flat.exists?(id: options.third_jockey_id)
      options.assign_attributes(attrs)
    end

    def update_jockey_relationship(horse:, horses:)
      finish = horses.find { |hash| hash[:id] == horse.id }
      entry = horse.race_entries.find_by(race:)
      relationship = horse.jockey_relationships.find_or_initialize_by(jockey: entry.jockey)
      relationship.experience += finish[:jockey_xp_gained].clamp(5, 20)
      relationship.experience = relationship.experience.clamp(0, 100)
      relationship.happiness += finish[:jockey_happiness_gained].clamp(5, 20)
      relationship.happiness = relationship.happiness.clamp(0, 100)
      relationship
    end

    def update_stats(horse:, horses:, race_horse:, date:, racetrack:)
      stats = horse.racing_stats
      return unless stats

      finish = horses.find { |hash| hash[:id] == horse.id }
      stats.energy -= finish[:energy_used]
      stats.energy = Config::Racing.minimum_energy if stats.energy < Config::Racing.minimum_energy
      fitness_gained = finish[:energy_used].abs * 2
      fitness_gained = fitness_gained.clamp(20, 100)
      stats.fitness += fitness_gained
      stats.fitness = Config::Racing.maximum_fitness if stats.fitness > Config::Racing.maximum_fitness
      stats.xp_current += finish[:experience_gained].clamp(5, 20)
      stats.xp_current = Config::Racing.maximum_xp if stats.xp_current > Config::Racing.maximum_xp
      stats.natural_energy_current -= [10, finish[:natural_energy_used]].min
      if (data = horse.race_metadata)
        data.update_grades(energy: stats.energy, fitness: stats.fitness)
        next_entry_date = horse.race_entries.where("date > ?", date).minimum(:date) || horse.future_race_entries.where("date > ?", date).minimum(:date)
        data.update(last_raced_at: date, next_entry_date:, racetrack:, location: racetrack.location, location_string: I18n.t("horse.location.at_racetrack", name: racetrack.name))
      end
      stats
    end

    def calculate_earnings(purse, finish_position)
      return 0 if finish_position > Config::Racing.purses.size
      return 0 unless Config::Racing.purses[finish_position - 1]

      (purse * Config::Racing.purses[finish_position - 1]).to_i
    end

    def calculate_points(finish, race_result)
      points_array = if race_result.stakes?
        Config::Racing.points[:stakes]
      elsif race_result.allowance?
        Config::Racing.points[:allowance]
      elsif race_result.claiming?
        Config::Racing.points[:claiming]
      elsif race_result.maiden?
        Config::Racing.points[:maiden]
      else
        []
      end
      return 0 if finish > points_array.size

      points_array[finish - 1]
    end

    def process_race_horses(race_result:, horses:)
      race_horses = []
      horses.each do |horse|
        race_horse = Racing::RaceResultHorse.find_or_initialize_by(race: race_result, horse_id: horse[:id])
        horse_class = Horses::Horse.find(horse[:id])
        entry = horse_class.race_entries.find_by(race:)
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
          points: calculate_points(horse[:finish_position], race_result).to_i
        }
        race_horse.assign_attributes(attrs)
        race_horses << race_horse
      end
      race_horses
    end

    def process_injuries(injuries:)
      injuries.each do |injury|
        horse = Horses::Horse.find(injury[:horse_id])
        Horses::Horse::Injurer.new(horse:, date:, injury: injury[:injury_type]).run
      end
    end
  end
end

