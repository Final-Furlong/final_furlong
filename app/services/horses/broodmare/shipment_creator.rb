module Horses
  module Broodmare
    class ShipmentCreator
      attr_reader :shipment, :horse

      def ship_horse(horse:, params:)
        @horse = horse
        @shipment = horse.broodmare_shipments.build
        result = Result.new(shipment:)
        stable = horse.manager

        shipment.starting_farm = horse.broodmare.current_location
        shipment.ending_farm = Account::Stable.find(params[:ending_farm])
        shipment.departure_date = params[:departure_date]
        shipment.mode = params[:mode].to_s
        route = lookup_route(shipment)
        if route.blank?
          shipment.valid?
          shipment.errors.add(:ending_location, :invalid)
          result.shipment = shipment
          return result
        end

        if shipment.mode == "road" && route[:road_days].blank? || shipment.mode == "air" && route[:air_days].blank?
          shipment.errors.add(:mode, :invalid)
          result.shipment = shipment
          return result
        end

        cost = (shipment.mode == "road") ? route[:road_cost] : route[:air_cost]
        if stable.available_balance.nil? || stable.available_balance <= cost
          shipment.errors.add(:mode, :cannot_afford)
          result.shipment = shipment
          return result
        end
        shipment.arrival_date = shipment.departure_date + days(shipment, route).days

        ActiveRecord::Base.transaction do
          if shipment.valid? && shipment.save
            unless shipment.future?
              legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
              legacy_horse&.update(InTransit: 1)
              description = I18n.t("services.shipment_creator.description", horse: horse.name, start:
                current_location_name, end: shipment.ending_farm.name)
              Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: cost.abs * -1)
            end

            result.created = true
          else
            result.created = false
            result.error = shipment.errors.full_messages.to_sentence
          end
          result.shipment = shipment
        end
        result
      end

      class Result
        attr_accessor :error, :created, :shipment

        def initialize(shipment:, created: false, error: nil)
          @created = created
          @shipment = shipment
          @error = nil
        end

        def created?
          @created
        end
      end

      def days(shipment, route)
        (shipment.mode == "road") ? route[:road_days] : route[:air_days]
      end

      def current_location_name
        horse.broodmare.current_location_name
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

