module Horses
  module Racing
    class ShipmentCreator
      attr_reader :shipment, :horse, :result

      def ship_horse(horse:, params:)
        @horse = horse
        @shipment = horse.send(association_name).build
        @result = Result.new(shipment:)
        stable = horse.manager

        shipment.starting_location = horse.race_metadata.location
        shipment.ending_location = if params[:ending_location] == "Farm"
          stable.racetrack.location
        else
          Location.find_by(id: params[:ending_location])
        end
        if shipment.ending_location.blank?
          shipment.valid?
          store_shipment_errors
          result.shipment = shipment
          return result
        end

        shipment.departure_date = params[:departure_date]
        shipment.mode = params[:mode].to_s
        route = lookup_route(shipment, stable)
        if route.blank?
          shipment.valid?
          shipment.errors.add(:ending_location, :invalid)
          store_shipment_errors
          result.shipment = shipment
          return result
        end

        if shipment.mode == "road" && route[:road_days].blank? || shipment.mode == "air" && route[:air_days].blank?
          shipment.errors.add(:mode, :invalid)
          store_shipment_errors
          result.shipment = shipment
          return result
        end

        cost = (shipment.mode == "road") ? route[:road_cost] : route[:air_cost]
        if stable.available_balance.nil? || stable.available_balance <= cost
          shipment.errors.add(:mode, :cannot_afford)
          store_shipment_errors
          result.shipment = shipment
          return result
        end
        shipment.arrival_date = shipment.departure_date + ((shipment.mode == "road") ? route[:road_days] : route[:air_days]).days
        shipment.shipping_type = shipping_type(params)

        ending_racetrack = ::Racing::Racetrack.find_by(location: shipment.ending_location)
        ActiveRecord::Base.transaction do
          shipment.scheduled = shipment.future?
          if shipment.valid? && shipment.save
            unless shipment.future?
              end_location_name = ending_location_name(stable, shipment.shipping_type)
              horse.race_metadata&.update(in_transit: true, location_string: end_location_name, location: shipment.ending_location, racetrack: ending_racetrack)
              description = I18n.t("services.shipment_creator.description", horse: horse.name, start: current_location_name, end: end_location_name)
              Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: cost.abs * -1)
            end

            result.created = true
          else
            result.created = false
            store_shipment_errors
          end
          result.shipment = shipment
        end
        if result.created && !shipment.future?
          location_id = if shipment.shipping_type == "track_to_farm"
            59
          else
            ::Legacy::Racetrack.where(name: ending_racetrack.name).order(ID: :asc).pick(:ID)
          end
          ::Legacy::Horse.transaction do
            legacy_horse = ::Legacy::Horse.find_by(ID: horse.legacy_id)
            legacy_horse&.update(InTransit: 1, Location: location_id)
          end
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

      def store_shipment_errors
        result.error = shipment.errors.full_messages.to_sentence
      end

      def shipping_type(params)
        if horse.racehorse? && horse.racing.at_farm?
          "farm_to_track"
        elsif params[:ending_location] == "Farm"
          "track_to_farm"
        else
          "track_to_track"
        end
      end

      def current_location_name
        horse.race_metadata.location.name
      end

      def ending_location_name(stable, shipping_type)
        if shipping_type == "track_to_track" || shipping_type == "farm_to_track"
          name = ::Racing::Racetrack.where(location: shipment.ending_location).pick(:name)
          I18n.t("horse.location.at_racetrack", name:)
        else
          stable.name
        end
      end

      def shipment_type
        horse.racehorse? ? Shipping::RacehorseShipment : Shipping::BroodmareShipment
      end

      def association_name
        horse.racehorse? ? :racing_shipments : :broodmare_shipments
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

