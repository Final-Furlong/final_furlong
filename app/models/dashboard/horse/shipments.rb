module Dashboard
  module Horse
    class Shipments
      attr_reader :horse, :shipments, :current_shipment

      def initialize(horse:)
        @horse = horse
        @shipments = []
        @shipments = load_shipments(horse.status)
        @current_shipment = @shipments.first if @shipments.present? && !@shipments.first[:start_date].future? && @shipments.first[:end_date].future?
      end

      private

      def in_transit?
        current_shipment.present?
      end

      def arrival_date?
        current_shipment[:end_date]
      end

      def load_shipments(status)
        class_name = (status.to_s.downcase == "racehorse") ?
                       Shipping::RacehorseShipment.includes(:starting_location, :ending_location) :
                       Shipping::BroodmareShipment.includes(:starting_farm, :ending_farm)
        class_name.where(horse:).order(departure_date: :desc).map do |shipment|
          hash = {
            id: shipment.id,
            start_date: shipment.departure_date,
            end_date: shipment.arrival_date,
            mode: shipment.mode
          }
          if shipment.respond_to?(:shipping_type)
            case shipment.shipping_type
            when "track_to_track"
              hash[:start_location] = racetracks.find { |racetrack| racetrack.location == shipment.starting_location }.name
              hash[:end_location] = racetracks.find { |racetrack| racetrack.location == shipment.ending_location }.name
            when "track_to_farm"
              hash[:start_location] = racetracks.find { |racetrack| racetrack.location == shipment.starting_location }.name
              hash[:end_location] = "Farm"
            when "farm_to_track"
              hash[:start_location] = "Farm"
              hash[:end_location] = racetracks.find { |racetrack| racetrack.location == shipment.ending_location }.name
            end
          else
            hash[:start_location] = shipment.starting_farm.name
            hash[:end_location] = shipment.ending_farm.name
          end
          hash
        end
      end

      def racetracks
        @racetracks ||= ::Racing::Racetrack.all
      end
    end
  end
end

