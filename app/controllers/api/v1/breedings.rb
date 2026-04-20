module Api
  module V1
    class Breedings < Grape::API
      include Api::V1::Defaults

      resource :breedings do
        desc "Update a breeding"
        params do
          requires :legacy_stud_id, type: Integer
          requires :legacy_mare_id, type: Integer
        end
        route_param :id do
          put "/" do
            stud = Horses::Horse.find_by!(legacy_id: params[:legacy_stud_id])
            mare = Horses::Horse.find_by!(legacy_id: params[:legacy_mare_id])
            year = Date.current.year

            breeding = Horses::Breeding.not_denied.find_by!(id: params[:id], year:, stud:, mare:)
            breeding ||= Horses::Breeding.not_denied.find_by!(id: params[:id], year:, stud:, open_booking: true, stable: mare.manager)

            result = Horses::BreedingProcessor.new.do_breeding(breeding:, mare:)
            error!({ error: "invalid", detail: result.error }, 500) unless result.updated?

            { breeding_id: result.breeding.id }
          end
        end
      end
    end
  end
end

