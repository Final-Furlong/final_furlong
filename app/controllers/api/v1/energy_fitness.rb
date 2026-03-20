module Api
  module V1
    class EnergyFitness < Grape::API
      include Api::V1::Defaults

      resource :energy_fitness do
        desc "Update a horse's energy and/or fitness"
        params do
          requires :id, type: Integer, desc: "Unique id for the Legacy::Horse"
          optional :energy_change, type: Integer, desc: "Amount of energy to modify"
          optional :fitness_change, type: Integer, desc: "Amount of fitness to decrease"
        end
        post "/" do
          horse = Horses::Horse.find_by(legacy_id: permitted_params[:id])
          next unless horse
          next unless horse.racehorse?
          stats = horse.racing_stats
          next unless stats
          data = horse.race_metadata
          next unless data

          if permitted_params[:energy_change].to_i != 0
            stats.energy += permitted_params[:energy_change].to_i
          end
          if permitted_params[:fitness_change].to_i != 0
            stats.fitness += permitted_params[:fitness_change].to_i
          end

          data.update_grades(energy: stats.energy, fitness: stats.fitness, update_legacy: true) if stats.save

          { updated: saved }
        end
      end
    end
  end
end

