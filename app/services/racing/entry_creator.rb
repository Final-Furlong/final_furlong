module Racing
  class EntryCreator
    attr_reader :race, :horse, :race_location, :ship_mode

    def create_entry(race:, horse:, stable:, first_jockey: nil, second_jockey: nil, third_jockey: nil, racing_style: nil, blinkers: nil, shadow_roll: nil, wraps: nil, figure_8: nil, no_whip: nil, shipping_mode: nil)
      @race = race
      @horse = horse
      @ship_mode = shipping_mode.to_s.inquiry
      race_date = Date.parse(race.date.to_s)
      entry = Racing::RaceEntry.new(race:, date: race_date, horse:, stable:)
      entry.racing_style = racing_style if racing_style.present?
      entry.first_jockey = Racing::Jockey.find_by(id: first_jockey) if first_jockey.present?
      entry.second_jockey = Racing::Jockey.find_by(id: second_jockey) if second_jockey.present?
      entry.third_jockey = Racing::Jockey.find_by(id: third_jockey) if third_jockey.present?
      entry.shipping_mode = ship_mode.presence
      entry.blinkers = blinkers.present?
      entry.shadow_roll = shadow_roll.present?
      entry.wraps = wraps.present?
      entry.figure_8 = figure_8.present?
      entry.no_whip = no_whip.present?
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

      if horse.race_entries.exists?(date: race_date)
        result.error = I18n.t("services.races.entry_creator.horse_has_entry", name: horse.name)
        return result
      end

      options = horse.race_options
      if !race.track_surface.jump? && options.racehorse_type != "flat"
        result.error = error("horse_not_flat")
        return result
      end

      if !horse_qualified?
        result.error = I18n.t("services.races.entry_creator.horse_not_qualified", name: horse.name)
        return result
      end

      if race.entries.where(stable:).count >= race.entry_limit
        result.error = error("max_entries_stable")
        return result
      end

      if race.entries.count >= Config::Racing.entry_limit_overall
        result.error = error("max_entries")
        return result
      end

      fee = race.entry_fee
      data = horse.race_metadata
      @race_location = race.racetrack.location
      max_travel_days = (race.travel_deadline - Date.current).to_i
      needs_shipment = false
      if data.location != race_location && !data.in_transit
        if ship_mode.present?
          route = Shipping::Route.with_locations(race_location, data.location).first
          costs = []
          days = []
          if ship_mode.road? && route.road_days && route.road_days < max_travel_days
            costs << route.road_cost
            days << route.road_days
          end
          if ship_mode.air? && route.air_days && route.air_days < max_travel_days
            costs << route.air_cost
            days << route.air_days
          end
          cost = costs.min
          days = days.min
          if cost.blank? || days.blank?
            result.error = I18n.t("services.races.entry_creator.horse_cannot_ship_in_time", name: horse.name)
            return result
          end
          needs_shipment = true
          fee += cost
        else
          result.error = I18n.t("services.races.entry_creator.horse_needs_shipping", name: horse.name)
          return result
        end
      elsif data.in_transit
        shipment = Shipping::RacehorseShipment.where(horse:).order(departure_date: :desc).first
        if shipment.ending_location != race_location
          result.error = I18n.t("services.races.entry_creator.horse_in_transit_elsewhere", name: horse.name)
          return result
        elsif shipment.arrival_date > race.travel_deadline
          result.error = I18n.t("services.races.entry_creator.horse_in_transit_not_in_time", name: horse.name)
          return result
        end
      end

      stop_boarding = false
      if (boarding = horse.current_boarding)
        stop_boarding = true
        fee += boarding.count_days * Config::Boarding.daily_fee
      end

      if fee > stable.available_balance
        result.error = error("cannot_afford_entry")
        return result
      end

      ActiveRecord::Base.transaction do
        if needs_shipment && ship_mode.present?
          Horses::Racing::ShipmentCreator.new.ship_horse(horse:, params: shipment_params)
        end
        if stop_boarding
          ::Horses::BoardingUpdater.new.stop_boarding(boarding: horse.current_boarding)
        end
        Racing::FutureRaceEntry.find_by(race:, horse:).destroy!
        description = I18n.t("racing.entry_options.budget_description", date: race.date, number: race.number, name: horse.name)
        Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: race.entry_fee.to_i * -1, activity_type: "entering")
        result.created = entry.save!
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

    def shipment_params
      { departure_date: Date.current, ending_location: race_location.id, mode: ship_mode }
    end

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
      I18n.t("services.races.entry_creator.#{key}")
    end
  end
end

