module Api
  module V1
    class Shipments < Grape::API
      include Api::V1::Defaults

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ messages: e.full_messages }, 400)
      end

      resource :shipments do
        desc "Create a shipment"
        params do
          requires :date, type: String, desc: "Date of the shipment"
          requires :legacy_id, type: Integer, desc: "Legacy ID of the horse", values: 1..10_000_000
          requires :shipment_type, type: String, desc: "Type of shipment", values: %w[track_to_track track_to_farm farm_to_track]
          requires :mode, type: String, desc: "Mode of shipment", values: %w[road air]
          optional :legacy_racetrack_id, type: Integer, desc: "Legacy ID of the destination racetrack"
        end
        post "/" do
          error!({ error: "invalid", detail: "Missing racetrack ID" }, 500) if invalid_ship_to_track?
          error!({ error: "invalid", detail: "Invalid date" }, 500) if permitted_paras[:date] < Date.current

          horse = Horses::Horse.find_by!(legacy_id: permitted_params[:legacy_id])
          location = if permitted_params[:shipment_type].end_with?("_to_farm")
            "Farm"
          else
            legacy_racetrack = Legacy::Racetrack.find!(permitted_params[:legacy_racetrack_id])
            racetrack = Racing::Racetrack.find_by!(name: legacy_racetrack.Name)
            racetrack.location
          end
          shipment_params = {
            departure_date: permitted_params[:date],
            ending_location: location,
            mode: permitted_params[:mode]
          }
          result = Horses::Racing::ShipmentCreator.new.ship_horse(horse:, params: shipment_params)
          error!({ error: "invalid", detail: result.error }, 500) unless result.created?

          { shipment_id: result.shipment&.id }
        end
      end

      private

      def invalid_ship_to_track?
        permitted_params[:legacy_racetrack_id].empty? &&
          permitted_params[:shipment_type].end_with?("_to_track")
      end
    end
  end
end

