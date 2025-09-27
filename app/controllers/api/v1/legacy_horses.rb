module Api
  module V1
    class LegacyHorses < Grape::API
      include Api::V1::Defaults

      resource :legacy_horses do
        desc "Migrate a legacy horse by ID"
        params do
          requires :id, type: Integer, desc: "Unique id for the Legacy::Horse"
        end
        post "/" do
          legacy_horse = Legacy::Horse.find_by!(ID: permitted_params[:id])
          result = MigrateLegacyHorseService.new(horse: legacy_horse).call
          error!({ error: "invalid", detail: "Failed to migrate horse with ID #{permitted_params[:id]}" }, 500) unless result

          horse = Horses::Horse.find_by(legacy_id: permitted_params[:id])
          error!({ error: "not_found", detail: "Failed to migrate horse with ID #{permitted_params[:id]}" }, 500) unless horse

          result = MigrateLegacyHorseAppearanceService.new(legacy_horse:)
          error!({ error: "invalid", detail: "Failed to migrate horse appearance with ID #{permitted_params[:id]}" }, 500) unless result

          { rails_id: horse.id }
        end
      end
    end
  end
end

