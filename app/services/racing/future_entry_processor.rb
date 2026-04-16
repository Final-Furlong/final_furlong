module Racing
  class FutureEntryProcessor
    attr_reader :max_entries

    FIVE_YEARS_IN_WEEKS = 5 * 52

    def process_races(date: Date.current)
      weekday = date.strftime("%A").downcase
      races = 0
      entered = 0
      skipped = 0
      errored = 0

      days_to_race = case weekday
      when "tuesday", "friday"
        8
      when "monday", "thursday"
        2
      end
      return { races:, entered:, skipped:, errored: } if days_to_race.nil?

      @max_entries = Config::Racing.send(:"future_entry_limit_#{days_to_race}_days_out")
      race_day = Date.current + days_to_race.days

      Racing::FutureRaceEntry.where(date: race_day).find_each do |entry|
        entry.destroy! if Racing::RaceEntry.exists?(date: race_day, race: entry.race, horse: entry.horse)
      end

      Racing::RaceSchedule.where(date: race_day).where.associated(:future_entries).distinct.find_each do |race|
        race_entered, race_errored, race_skipped = process_race(race)
        races += 1
        entered += race_entered
        skipped += race_skipped
        errored += race_errored
      end
      do_notifications(race_day)
      { races:, entered:, skipped:, errored: }
    end

    private

    def do_notifications(date)
      stable_entry_counts = Racing::FutureRaceEntry.where(date:).group(:stable_id).count
      stable_entry_counts.each do |stable_id, count|
        if count.positive?
          stable = Account::Stable.find(stable_id)
          success_count = Racing::FutureRaceEntry.succeeded.where(stable:).count
          errored_count = Racing::FutureRaceEntry.errored.where(stable:).count
          skipped_count = Racing::FutureRaceEntry.skipped.where(stable:).count
          Game::NotificationCreator.new.create_notification(
            type: ::FutureEntryProcessingNotification,
            user: stable.user,
            params: {
              date:,
              succeeded: success_count,
              errored: errored_count,
              skipped: skipped_count
            }
          )
        end
      end
    end

    def process_race(race)
      entered = 0
      skipped = 0
      errored = 0
      race.future_entries.where(auto_enter: false).find_each do |entry|
        skipped += 1
        entry.update!(entry_status: "skipped")
      end

      max_race_entries = max_entries - race.entries_count
      unless max_race_entries.positive?
        race.future_entries.where(auto_enter: true).find_each do |entry|
          skipped += 1
          entry.update!(entry_status: "skipped")
        end
        return
      end

      possible_entries = []
      race.future_entries.where(auto_enter: true).find_each do |entry|
        entry_validation = validate_entry(entry, race)
        if entry_validation[:error]
          errored += 1
          entry.update!(entry_status: "errored", entry_error: entry_validation[:message])
        else
          entry.ship_mode = entry_validation[:ship_mode] if entry_validation[:ship_mode].present?
          possible_entries << entry
        end
      end

      entry_count = race.entries_count
      possible_entries = sort_entries(possible_entries, race, max_race_entries) if possible_entries.count > max_race_entries
      while entry_count < max_race_entries && possible_entries.size.positive?
        possible_entries.each do |entry|
          result = enter_race(entry, race)
          if result.created?
            entered += 1
            entry_count += 1
            possible_entries.delete(entry)
            entry.update!(entry_status: "entered")
          else
            pd "skipped, #{result.error}"
            skipped += 1
            entry.update!(entry_status: "skipped")
            possible_entries.delete(entry)
          end
        end
      end

      possible_entries.each do |entry|
        if entry.reload.entry_status.blank?
          pd "final skip"
          entry.update!(entry_status: "skipped")
          skipped += 1
        end
      end
      [entered, errored, skipped]
    end

    def enter_race(entry, race)
      horse = entry.horse
      attrs = { race:, horse:, stable: horse.manager, first_jockey: entry.first_jockey_id, second_jockey: entry.second_jockey_id, third_jockey: entry.third_jockey_id,
                racing_style: entry.racing_style, shipping_mode: entry.ship_mode }
      attrs[:blinkers] = true if entry.blinkers
      attrs[:shadow_roll] = true if entry.shadow_roll
      attrs[:wraps] = true if entry.wraps
      attrs[:no_whip] = true if entry.no_whip
      attrs[:figure_8] = true if entry.figure_8
      Racing::EntryCreator.new.create_entry(**attrs)
    end

    def validate_entry(entry, race)
      horse = entry.horse
      stable = horse.manager
      result = { error: false, message: nil, ship_mode: nil }
      if race.entries_count == Config::Racing.entry_limit_overall
        result[:message] = "race_full"
      elsif race.entries.where(stable:).count >= race.entry_limit
        result[:message] = "max_entries"
      elsif race.requires_qualification? # TODO: Handle this case
        result[:message] = "not_qualified"
      elsif horse.race_entries.exists?(date: race.date)
        result[:message] = "already_entered"
      elsif !race.track_surface.jump? && horse.race_options.racehorse_type != "flat"
        result[:message] = "not_qualified"
      elsif !horse_qualified?(horse, race)
        result[:message] = "not_qualified"
      end
      if result[:message].nil? && horse.race_metadata.location != race.racetrack.location
        if !entry.auto_ship
          result[:message] = "not_at_track"
        elsif horse.race_metadata.in_transit
          shipment = Shipping::RacehorseShipment.where(horse:).order(departure_date: :desc).first
          if shipment.ending_location != race.racetrack.location || shipment.arrival_date > race.travel_deadline
            result[:message] = "cannot_ship_in_time"
          end
        else
          max_travel_days = (race.travel_deadline - Date.current).to_i
          route = Shipping::Route.with_locations(race.racetrack.location, horse.race_metadata.location).first
          costs = []
          days = []
          if (entry.ship_mode.blank? || entry.ship_mode.road?) && route.road_days && route.road_days < max_travel_days
            result[:ship_mode] = "road"
            costs << route.road_cost
            days << route.road_days
          end
          if (entry.ship_mode.blank? || entry.ship_mode.air?) && route.air_days && route.air_days < max_travel_days
            result[:ship_mode] = "air" if result[:ship_mode].blank?
            costs << route.air_cost
            days << route.air_days
          end
          cost = costs.min
          days = days.min
          if cost.blank? || days.blank?
            result[:message] = "cannot_ship_in_time"
          elsif (cost + race.entry_fee) > stable.available_balance
            result[:message] = "cannot_afford_shipping"
          end
        end
      end
      if result[:message].nil? && race.entry_fee > stable.available_balance
        result[:message] = "cannot_afford_entry"
      end
      result[:error] = !result[:message].nil?
      result
    end

    def horse_qualified?(horse, race)
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

    def sort_entries(entries, race, max)
      entries.shuffle
      if race.race_type != "stakes"
        entries.sort_by { |entry| entry.horse.race_metadata.last_raced_at ? (Date.current - date.last_raced_at).to_i / 7 : FIVE_YEARS_IN_WEEKS }.reverse
      else
        entries.sort_by do |entry|
          base_query = Racing::RaceResult.where("date > ?", 1.year.ago).where(horse: entry.horse)
          total_points = base_query.sum(:points)
          total_starts = base_query.count
          average_points = total_points / total_starts
          stakes_wins = base_query.joins(:race).merge(Racing::RaceResult.by_type("stakes")).by_finish(1).count
          stakes_places = base_query.joins(:race).merge(Racing::RaceResult.by_type("stakes")).by_finish(3).count

          [average_points, stakes_wins, stakes_places]
        end.reverse
      end
      entries
    end
  end
end

