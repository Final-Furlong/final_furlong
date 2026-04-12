module Horses
  module Racing
    class FutureShipmentProcessor
      attr_reader :shipment, :horse

      def ship_horse(shipment:)
        @shipment = shipment
        return if shipment.future?
        return unless shipment.scheduled?

        @horse = shipment.horse
        return unless horse.racehorse?

        stable = horse.manager
        end_location_name = ending_location_name(stable, shipment.shipping_type)
        if horse.racing.current_location != shipment.starting_location
          notify_failed_shipment(end_location_name, stable)
          return
        end

        route = lookup_route(shipment, stable)
        cost = (shipment.mode == "road") ? route[:road_cost] : route[:air_cost]
        if stable.available_balance.nil? || stable.available_balance <= cost
          notify_failed_shipment(end_location_name, stable)
          return
        end

        if horse.race_entries.present?
          next_entry = horse.race_entries.joins(:race).merge(Racing::RaceSchedule.order(date: :asc)).first
          race = next_entry.race
          if race.racetrack.location != shipment.ending_location || shipment.arrival_date > race.date
            notify_failed_shipment(end_location_name, stable)
            return
          end
        end

        current_location = horse.racing.current_location_name
        saved = false
        ActiveRecord::Base.transaction do
          shipment.update(scheduled: false)
          horse.race_metadata&.update(in_transit: true, last_shipped_at: Time.current, location_string: end_location_name)
          description = I18n.t("services.shipment_creator.description", horse: horse.name, start: current_location, end: end_location_name)
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: cost.abs * -1)
          saved = true
        end
        if saved
          location_id = if shipment.shipping_type == "track_to_farm"
            59
          else
            track_name = Racing::Racetrack.where(location: shipment.ending_location).pick(:name)
            Legacy::Racetrack.where(name: track_name).order(ID: :asc).pick(:ID)
          end
          Legacy::Horse.transaction do
            legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
            legacy_horse&.update(InTransit: 1, Location: location_id)
            Legacy::ViewRacehorses.find_by(horse_id: horse.legacy_id)&.update(in_transit: 1, location: location_id)
            if location_id != 59
              track_name = Racing::Racetrack.where(location: shipment.ending_location).pick(:name)
              Legacy::ViewTrainingSchedules.find_by(horse_id: horse.legacy_id)&.update(track_name:)
            end
          end
        end
      end

      private

      def notify_failed_shipment(location, stable)
        Game::NotificationCreator.new.create_notification(
          type: ::FailedFutureShipmentNotification,
          user: stable.user,
          params: {
            horse_id: horse.slug,
            horse_name: horse.name,
            location:
          }
        )
      end

      def ending_location_name(stable, shipping_type)
        if shipping_type == "track_to_track" || shipping_type == "farm_to_track"
          name = ::Racing::Racetrack.where(location: shipment.ending_location).pick(:name)
          I18n.t("horse.location.at_racetrack", name:)
        else
          stable.name
        end
      end

      def lookup_route(shipment, stable)
        if shipment.starting_location == shipment.ending_location
          Shipping::Route.new(miles: stable.miles_from_track, road_days: 1, road_cost: 25)
        else
          Shipping::Route.find_by(starting_location: shipment.starting_location,
            ending_location: shipment.ending_location)
        end
      end
    end
  end
end

