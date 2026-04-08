module Racing
  class FutureEntryCreator
    attr_reader :race, :horse, :ship_date

    def create_entry(race:, horse:, stable:, first_jockey: nil, second_jockey: nil, third_jockey: nil,
      auto_enter: false, racing_style: nil, blinkers: nil, shadow_roll: nil, wraps: nil, figure_8: nil, no_whip: nil,
      shipping_mode: nil, shipping_date: nil, ship_only_if_horse_is_entered: false)
      @race = race
      @horse = horse
      @ship_date = shipping_date.to_s.inquiry
      race_date = Date.parse(race.date.to_s)
      entry = Racing::FutureRaceEntry.new(race:, date: race_date, horse:)
      entry.stable = stable
      entry.racing_style = racing_style if racing_style.present?
      entry.first_jockey = Racing::Jockey.find_by(id: first_jockey) if first_jockey.present?
      entry.second_jockey = Racing::Jockey.find_by(id: second_jockey) if second_jockey.present?
      entry.third_jockey = Racing::Jockey.find_by(id: third_jockey) if third_jockey.present?
      entry.ship_mode = shipping_mode.presence
      entry.blinkers = blinkers.present?
      entry.shadow_roll = shadow_roll.present?
      entry.wraps = wraps.present?
      entry.figure_8 = figure_8.present?
      entry.no_whip = no_whip.present?
      entry.auto_enter = auto_enter
      entry.ship_only_if_horse_is_entered = ship_only_if_horse_is_entered
      if ship_date.entries_open?
        entry.ship_when_entries_open = true
      elsif ship_date.horse_entered?
        entry.ship_when_horse_is_entered = true
      else
        entry.ship_date = ship_date
      end
      result = Result.new(entry:)

      if Date.current >= race.entry_open_date
        result.error = error("race_not_future")
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

      if horse.future_race_entries.exists?(date: race_date)
        result.error = I18n.t("services.races.future_entry_creator.horse_has_entry", name: horse.name)
        return result
      end

      options = horse.race_options
      if !race.track_surface.jump? && options.racehorse_type != "flat"
        result.error = error("horse_not_flat")
        return result
      end

      if !horse_qualified?
        result.error = I18n.t("services.races.future_entry_creator.horse_not_qualified", name: horse.name)
        return result
      end

      if race.future_entries.where(stable:).count >= race.entry_limit
        result.error = error("max_entries_stable")
        return result
      end

      if race.future_entries.where(horse:).count >= Config::Racing.future_race_limit
        result.error = error("max_entries_horse")
        return result
      end

      ActiveRecord::Base.transaction do
        result.created = entry.save!
        data = horse.race_metadata
        data.next_entry_date = race.date if data.next_entry_date.blank? || data.next_entry_date > race.date
        data.save!
      end
      result
    end

    class Result
      attr_accessor :entry, :created, :error

      def initialize(entry:, created: false, error: nil)
        @entry = entry
        @created = created
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def horse_qualified?
      return true if race.race_type.allowance? || race.race_type.stakes?

      qualification = horse.race_qualification
      return false if race.race_type.maiden? && !qualification.maiden_qualified
      return false if race.race_type.claiming? && !qualification.claiming_qualified
      return false if race.race_type.starter_allowance? && !qualification.starter_allowance_qualified
      return false if race.race_type.nw1_allowance? && !qualification.nw1_allowance_qualified
      return false if race.race_type.nw2_allowance? && !qualification.nw2_allowance_qualified
      return false if race.race_type.nw3_allowance? && !qualification.nw3_allowance_qualified

      true
    end

    def error(key)
      I18n.t("services.races.future_entry_creator.#{key}")
    end
  end
end

