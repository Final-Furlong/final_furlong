module Api
  module V1
    class Jockeys < Grape::API
      include Api::V1::Defaults

      resource :jockeys do
        desc "Fetch jockey info"
        params do
          requires :id, type: Integer, desc: "Jockey ID"
        end
        route_param :id do
          get do
            jockey = Racing::Jockey.find(params[:id])
            ::Racing::JockeyBlueprint.render_as_json(jockey)
          end
        end
      end
    end
  end
end

