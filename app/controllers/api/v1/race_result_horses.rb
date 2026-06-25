module Api
  module V1
    class RaceResultHorses < Grape::API
      include Api::V1::Defaults

      resource :race_points do
        desc "Fetch total points for a given horse"
        params do
          requires :id, type: Integer
        end
        route_param :id do
          get do
            horse = ::Horses::Horse.find_by(id: permitted_params[:id])
            points = 0
            if horse
              points = horse.lifetime_race_record&.points.to_i
            end
            { points: }
          end
        end
      end
    end
  end
end

