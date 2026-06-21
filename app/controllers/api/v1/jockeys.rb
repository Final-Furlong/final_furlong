module Api
  module V1
    class Jockeys < Grape::API
      include Api::V1::Defaults

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ messages: e.full_messages }, 400)
      end

      resource :jockeys do
        desc "Fetch jockey info"
        params do
          requires :id, type: Integer, desc: "Jockey ID"
        end
        route_param :id do
          get do
            pd params
            Racing::Jockey.find(params[:id])
          end
        end
      end
    end
  end
end

