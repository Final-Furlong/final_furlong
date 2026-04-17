module Racing
  class GameEntryCreator
    attr_reader :race, :horse, :race_location

    def create_entry(race:, horse:)
      @race = race
      @horse = horse
      stable = Account::Stable.find_by(name: Config::Game.stable)
      race_date = Date.parse(race.date.to_s)
      entry = Racing::RaceEntry.new(race:, date: race_date, horse:, stable:)
      result = Result.new(entry:)

      return result if Date.current < race.entry_open_date
      return result if !horse.racehorse?
      return result if horse.manager != stable
      return result if horse.race_entries.exists?(date: race_date)
      return result if !race.track_surface.jump? && horse.race_options.racehorse_type != "flat"
      return result if race.entries.count >= Config::Racing.entry_limit_overall

      fee = race.entry_fee
      data = horse.race_metadata
      @race_location = race.racetrack.location
      needs_shipment = false
      if data.location != race_location && !data.in_transit
        needs_shipment = true
      elsif data.in_transit
        shipment = Shipping::RacehorseShipment.where(horse:).order(departure_date: :desc).first
        if shipment.ending_location != race_location
          result.error = I18n.t("services.races.entry_creator.horse_in_transit_elsewhere", name: horse.name)
          return result
        elsif shipment.arrival_date > race.entry_deadline
          result.error = I18n.t("services.races.entry_creator.horse_in_transit_not_in_time", name: horse.name)
          return result
        end
      end

      stop_boarding = false
      if (boarding = horse.current_boarding)
        stop_boarding = true
        fee += boarding.count_days * Config::Boarding.daily_fee
      end

      return result if fee > stable.available_balance

      ActiveRecord::Base.transaction do
        horse.race_metadata.update(location: @race_location, racetrack: race.racetrack) if needs_shipment
        ::Horses::BoardingUpdater.new.stop_boarding(boarding: horse.current_boarding) if stop_boarding
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

