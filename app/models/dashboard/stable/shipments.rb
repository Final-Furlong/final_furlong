module Dashboard
  module Stable
    class Shipments
      attr_reader :shipments, :current_racehorse_shipments,
        :scheduled_racehorse_shipments,
        :current_broodmare_shipments, :scheduled_broodmare_shipments

      def initialize(query:)
        @current_racehorse_shipments = query.racehorse.joins(:racing_shipments).where(racing_shipments: { departure_date: ..Date.current })
        @scheduled_racehorse_shipments = query.racehorse.joins(:racing_shipments).where("racehorse_shipments.departure_date > ?", Date.current)
        @current_broodmare_shipments = query.broodmare.joins(:broodmare_shipments).where(broodmare_shipments: { departure_date: ..Date.current })
        @scheduled_broodmare_shipments = query.broodmare.joins(:broodmare_shipments).where("broodmare_shipments.departure_date > ?", Date.current)
      end

      def active_tab
        if current_racehorses_count >= scheduled_racehorses_count &&
            current_racehorses_count >= current_broodmares_count &&
            current_racehorses_count >= scheduled_broodmares_count
          :current_racehorses
        elsif scheduled_racehorses_count >= current_broodmares_count &&
            scheduled_racehorses_count >= scheduled_broodmares_count
          :scheduled_racehorses
        elsif current_broodmares_count >= scheduled_broodmares_count
          :current_broodmares
        else
          :scheduled_broodmares
        end
      end

      def data(shipment)
        hash = {}
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
          hash[:start_location] = shipment&.starting_farm&.name
          hash[:end_location] = shipment&.ending_farm&.name
        end
        hash
      end

      def racetracks
        @racetracks ||= ::Racing::Racetrack.includes(:location).all
      end

      def current_racehorses_count
        current_racehorse_shipments.count
      end

      def scheduled_racehorses_count
        scheduled_racehorse_shipments.count
      end

      def current_broodmares_count
        current_broodmare_shipments.count
      end

      def scheduled_broodmares_count
        scheduled_broodmare_shipments.count
      end
    end
  end
end

