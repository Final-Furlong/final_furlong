module Api
  module V1
    class Horses < Grape::API
      include Api::V1::Defaults

      resource :horses do
        desc "Fetch horse info"
        params do
          requires :id, type: Integer, desc: "Horse ID"
        end
        route_param :id do
          get do
            horse = ::Horses::Horse.find(params[:id])
            ::Horses::RacehorseBlueprint.render_as_json(horse)
          end
        end
      end
    end
  end
end

