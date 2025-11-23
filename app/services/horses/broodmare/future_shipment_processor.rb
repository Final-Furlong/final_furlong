module Horses
  module Broodmare
    class FutureShipmentProcessor
      attr_reader :shipment, :horse

      def ship_horse(shipment:)
        @shipment = shipment
        @horse = shipment.horse
        stable = horse.manager

        if horse.broodmare.current_location != shipment.starting_farm
          return
        end

        route = lookup_route(shipment)
        cost = (shipment.mode == "road") ? route[:road_cost] : route[:air_cost]
        if stable.available_balance.nil? || stable.available_balance <= cost
          return
        end

        ActiveRecord::Base.transaction do
          legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
          legacy_horse&.update(InTransit: 1)
          description = I18n.t("services.shipment_creator.description", horse: horse.name, start:
            current_location_name, end: shipment.ending_farm.name)
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: cost.abs * -1)
        end
      end

      private

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

