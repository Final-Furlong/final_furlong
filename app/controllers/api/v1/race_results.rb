module Api
  module V1
    class RaceResults < Grape::API
      include Api::V1::Defaults

      resource :race_results do
        desc "Create a race result"
        params do
          requires :date, type: String, desc: "Date of the race"
          requires :number, type: Integer, desc: "Number of the race", values: 1..50
          requires :time, type: Float, desc: "Time in seconds"
          requires :horses, type: Array, length: { min: 1, max: 14 } do
            requires :finish_position, type: Integer, desc: "Finish Position", values: 1..14
            requires :post_parade, type: Integer, desc: "Post Position", values: 1..14
            requires :positions, type: String, desc: "Positions"
            requires :margins, type: String, desc: "Margins"
            requires :fractions, type: String, desc: "Fractions"
            requires :id, type: Integer, values: 1..10_000_000
            requires :speed_factor, type: Integer, desc: "Speed Factor", values: 0..1_000
            requires :energy_used, type: Integer, desc: "Energy Used In The Race", values: 0..2_000
            requires :experience_gained, type: Integer, desc: "XP Gained In The Race", values: 0..2_000
            requires :fitness_gained, type: Integer, desc: "Fitness Gained In The Race", values: 0..2_000
            requires :natural_energy_used, type: Integer, desc: "Natural Energy Used In The Race", values: 0..2_000
            requires :jockey_happiness_gained, type: Integer, desc: "Amount of happiness gained with the jockey"
            requires :jockey_xp_gained, type: Integer, desc: "Amount of experience gained with the jockey"
          end
        end
        post "/" do
          error!({ error: "invalid", detail: "Missing horses" }, 500) if permitted_params[:horses].empty?

          race = Racing::RaceSchedule.find_by(date: permitted_params[:date], number: permitted_params[:number])
          if permitted_params[:number] > 1
            previous_number = permitted_params[:number] - 1
            result = Racing::RaceResult.where(date: permitted_params[:date], number: previous_number)
            error!({ error: "invalid", detail: "Cannot skip number #{previous_number}" }, 500) unless result.exists?
          end
          result = Racing::RaceResultCreator.new.create_result(race:, time: permitted_params[:time], horses: permitted_params[:horses])
          error!({ error: "invalid", detail: "Race error: #{result.error}" }, 500) unless result.created?

          { race_result_id: result.race_result&.id }
        end
      end
    end
  end
end

