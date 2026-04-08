module Racing
  class EntryUpdater
    attr_reader :entry, :race, :horse

    def update_entry(entry:, stable:, first_jockey: nil, second_jockey: nil, third_jockey: nil, racing_style: nil, blinkers: nil, shadow_roll: nil, wraps: nil, figure_8: nil, no_whip: nil, shipping_mode: nil)
      @entry = entry
      @race = entry.race
      @horse = entry.horse
      entry.racing_style = (racing_style.presence)
      entry.first_jockey = Racing::Jockey.find_by(id: first_jockey)
      entry.second_jockey = Racing::Jockey.find_by(id: second_jockey)
      entry.third_jockey = Racing::Jockey.find_by(id: third_jockey)
      entry.blinkers = blinkers.present?
      entry.shadow_roll = shadow_roll.present?
      entry.wraps = wraps.present?
      entry.figure_8 = figure_8.present?
      entry.no_whip = no_whip.present?
      pd entry
      result = Result.new(entry:)

      if race.entry_deadline < Date.current
        result.error = error("deadline_past")
        return result
      end

      if Date.current < race.entry_open_date
        result.error = error("entries_not_open")
        return result
      end

      if !horse.racehorse?
        result.error = error("horse_not_racehorse")
        return result
      end

      if horse.manager != stable
        result.error = error("stable_not_manager")
        return result
      end

      result.updated = entry.save!
      result
    end

    class Result
      attr_accessor :entry, :updated, :error

      def initialize(entry:, updated: false, error: nil)
        @entry = entry
        @updated = updated
        @error = error
      end

      def updated?
        @updated
      end
    end

    private

    def error(key)
      I18n.t("services.races.entry_creator.#{key}")
    end
  end
end

