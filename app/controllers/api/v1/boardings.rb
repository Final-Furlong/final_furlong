module Api
  module V1
    class Boardings < Grape::API
      include Api::V1::Defaults

      resource :boardings do
        desc "Create a boarding entry for a horse"
        params do
          requires :legacy_horse_id, type: Integer, desc: "Legacy ID for the horse"
          requires :legacy_racetrack_id, type: Integer, desc: "Legacy ID for the racetrack"
        end
        post "/" do
          horse = Horses::Horse.find_by!(legacy_id: params[:legacy_horse_id])
          legacy_racetrack = Legacy::Racetrack.find_by!(ID: params[:legacy_racetrack_id])
          result = Horses::BoardingCreator.new.start_boarding(horse:, legacy_racetrack:)
          error!({ error: "invalid", detail: result.error }, 500) unless result.created?

          { boarding_id: result.boarding.id }
        end

        desc "Updates a boarding entry for a horse with end date"
        route_param :id do
          put "/" do
            boarding = Horses::Boarding.find(params[:id])
            result = Horses::BoardingUpdater.new.stop_boarding(boarding:)
            error!({ error: "invalid", detail: result.error }, 500) unless result.updated?

            { completed: true }
          end
        end

        desc "Delete a boarding entry for a horse"
        route_param :id do
          delete "/" do
            boarding = Horses::Boarding.find(params[:id])
            error!({ error: "invalid", detail: I18n.t("services.boarding.deletion.in_progress") }, 500) unless boarding.today?

            boarding.destroy!

            { deleted: true }
          end
        end
      end
    end
  end
end

