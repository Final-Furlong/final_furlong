module Horses
  module Broodmare
    class FutureShipmentProcessor
      attr_reader :shipment, :horse

      def ship_horse(shipment:)
        @shipment = shipment
        return if shipment.future?
        return unless shipment.scheduled?

        @horse = shipment.horse
        return unless horse.broodmare?

        stable = horse.manager
        end_location_name = shipment.ending_farm.name

        if horse.broodmare.current_location != shipment.starting_farm
          notify_failed_shipment(end_location_name, stable)
          return
        end

        route = lookup_route(shipment)
        cost = (shipment.mode == "road") ? route[:road_cost] : route[:air_cost]
        if stable.available_balance.nil? || stable.available_balance <= cost
          notify_failed_shipment(end_location_name, stable)
          return
        end

        saved = false
        ActiveRecord::Base.transaction do
          shipment.update(scheduled: false)
          description = I18n.t("services.shipment_creator.description", horse: horse.name, start: current_location_name, end: end_location_name)
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: cost.abs * -1)
          saved = true
        end
        if saved
          Legacy::Horse.transaction do
            location_id = Legacy::Stable.where(name: shipment.ending_farm.name).pick(:ID)
            legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
            legacy_horse&.update(InTransit: 1, Location: location_id)
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

      def lookup_route(shipment)
        starting_location = shipment.starting_farm.racetrack.location
        ending_location = shipment.ending_farm.racetrack.location
        if starting_location == ending_location
          Shipping::Route.new(miles: shipment.starting_farm.miles_from_track, road_days: 1, road_cost: 25)
        else
          Shipping::Route.find_by(starting_location:, ending_location:)
        end
      end
    end
  end
end

