module Horses
  module Racing
    class FutureShipmentCreator
      attr_reader :shipment, :horse

      def ship_horse(shipment:)
        @shipment = shipment
        @horse = shipment.horse
        stable = horse.manager

        if horse.racing.current_location != shipment.starting_location
          return
        end

        route = lookup_route(shipment, stable)
        cost = (shipment.mode == "road") ? route[:road_cost] : route[:air_cost]
        if stable.available_balance.nil? || stable.available_balance <= cost
          return
        end

        current_location = horse.racing.current_location_name
        ActiveRecord::Base.transaction do
          # TODO: update race stats to flag in transit
          Legacy::Horse.find_by(ID: horse.legacy_id)&.update(InTransit: 1)
          Legacy::ViewRacehorses.find_by(horse_id: horse.legacy_id)&.update(in_transit: 1)
          description = I18n.t("services.shipment_creator.description", horse: horse.name, start:
            current_location, end: ending_location_name(shipment, stable))
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: cost.abs * -1)
        end
      end

      private

      def ending_location_name(shipment, stable)
        if shipment.shipping_type == "track_to_farm"
          stable.name
        else
          Racing::Racetrack.where(location: shipment.ending_location).pick(:name)
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

