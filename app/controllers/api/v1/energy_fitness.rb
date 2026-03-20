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

          saved = false
          energy_grade, fitness_grade = "", ""
          ActiveRecord::Base.transaction do
            saved = stats.save
            energy_grade, fitness_grade = data.update_grades(energy: stats.energy, fitness: stats.fitness)
          end
          if saved && energy_grade.present? && fitness_grade.present?
            Legacy::Horse.where(ID: permitted_params[:id]).update(
              EnergyCurrent: stats.energy, Fitness: stats.fitness,
              DisplayEnergy: energy_grade, DisplayFitness: fitness_grade
            )
          end

          { updated: saved }
        end
      end
    end
  end
end

