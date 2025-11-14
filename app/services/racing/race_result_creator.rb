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
            race_record = update_race_record(race_result:, surface:, race_horse:)
            next if race_horse.save! && race_record.save!

            result.created = false
            raise ActiveRecord::Rollback, race_horse.errors.full_messages.to_sentence
          end
        end
        trigger_horse_attribute_updates(horses:)
        Racing::RaceDayUpdaterJob.perform_later if max_race?(date:, number:)
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

    def update_race_record(race_result:, surface:, race_horse:)
      horse = race_horse.horse
      record = horse.race_records.find_or_initialize_by(year: race_result.date.year, result_type: surface.surface.to_s.downcase)
      record.starts += 1
      stakes_race = race_result.race_type == "stakes"
      record.stakes_starts += 1 if stakes_race
      case race_horse.finish_position
      when 1
        record.wins += 1
        record.stakes_wins += 1 if stakes_race
        record.earnings += (race_result.purse * 0.6).to_i
      when 2
        record.seconds += 1
        record.stakes_seconds += 1 if stakes_race
        record.earnings += (race_result.purse * 0.2).to_i
      when 3
        record.thirds += 1
        record.stakes_thirds += 1 if stakes_race
        record.earnings += (race_result.purse * 0.1).to_i
      when 4
        record.fourths += 1
        record.stakes_fourths += 1 if stakes_race
        record.earnings += (race_result.purse * 0.07).to_i
      when 5
        record.earnings += (race_result.purse * 0.03).to_i
      end
      record
    end

    def process_race_horses(race_result:, horses:)
      race_horses = []
      horses.each do |horse|
        race_horse = Racing::RaceResultHorse.find_or_initialize_by(race: race_result, legacy_horse_id: horse[:legacy_id])
        horse_class = Horses::Horse.find_by(legacy_id: horse[:legacy_id])
        jockey = Racing::Jockey.find_by(legacy_id: horse[:jockey_legacy_id])
        odd = Racing::Odd.find_by(display: horse[:odds])
        attrs = {
          horse: horse_class,
          post_parade: horse[:post_parade],
          positions: horse[:positions],
          margins: horse[:margins],
          fractions: horse[:fractions],
          speed_factor: horse[:speed_factor],
          finish_position: horse[:finish_position],
          weight: horse[:weight],
          jockey:,
          odd:,
          blinkers: horse[:blinkers],
          shadow_roll: horse[:shadow_roll],
          wraps: horse[:wraps],
          figure_8: horse[:figure_8],
          no_whip: horse[:no_whip],
          created_at: race_result.date.beginning_of_day + race_result.number.minutes + horse[:post_parade].minutes
        }
        race_horse.assign_attributes(attrs)
        race_horses << race_horse
      end
      race_horses
    end
  end
end

