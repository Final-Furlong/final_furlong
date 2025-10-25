module Api
  module V1
    class RaceResults < Grape::API
      include Api::V1::Defaults

      resource :race_results do
        desc "Create a race result"
        params do
          requires :date, type: String, desc: "Date of the race"
          requires :number, type: Integer, desc: "Number of the race"
          requires :race_type, type: String, desc: "Race Type"
          requires :distance, type: Float, desc: "Distance"
          requires :age, type: String, values: %w[2 2+ 3 3+ 4 4+], desc: "Race age"
          requires :track_name, type: String, desc: "Track Name"
          requires :track_surface, type: String, values: %w[dirt turf steeplechase], desc: "Track surface"
          requires :condition, type: String, values: %w[fast good slow wet], desc: "Track condition"
          requires :time, type: Float, desc: "Time in seconds"
          requires :purse, type: Integer, desc: "Purse"
          optional :male_only, type: Boolean, default: false, desc: "Male only flag"
          optional :female_only, type: Boolean, default: false, desc: "Female only flag"
          optional :grade, type: String, values: ["Ungraded", "Grade 3", "Grade 2", "Grade 1"], desc: "Race Grade"
          given race_type: ->(value) { value == "claiming" } do
            requires :claiming_price, Integer, desc: "Claiming Price"
          end
          given :grade do
            requires :name, String, desc: "Race Name"
          end
          requires :horses, type: Array, allow_blank: false do
            requires :finish_position, type: Integer, desc: "Finish Position"
            requires :post_parade, type: Integer, desc: "Post Position"
            requires :positions, type: String, desc: "Positions"
            requires :margins, type: String, desc: "Margins"
            requires :fractions, type: String, desc: "Fractions"
            requires :legacy_id, type: Integer, desc: "Legacy ID"
            requires :jockey_legacy_id, type: Integer, desc: "Jockey Legacy ID"
            requires :odds, type: String, desc: "Odds"
            requires :weight, type: Integer, desc: "Weight"
            requires :speed_factor, type: Integer, desc: "Speed Factor"
            optional :blinkers, type: Boolean, default: false, desc: "Blinkers"
            optional :shadow_roll, type: Boolean, default: false, desc: "Shadow Roll"
            optional :wraps, type: Boolean, default: false, desc: "Wraps"
            optional :figure_8, type: Boolean, default: false, desc: "Figure 8"
            optional :no_whip, type: Boolean, default: false, desc: "No Whip"
          end
        end
        post "/" do
          error!({ error: "invalid", detail: "Missing horses" }, 500) if permitted_params[:horses].empty?

          track_surface_name = permitted_params.delete(:track_surface).downcase
          racetrack = permitted_params.delete(:track_name)
          surface = Racing::TrackSurface.joins(:racetrack).find_by(surface: track_surface_name, racetracks: { name: racetrack })

          result = Racing::RaceResultCreator.new.create_result(
            date: permitted_params[:date],
            number: permitted_params[:number],
            race_type: permitted_params[:race_type],
            distance: permitted_params[:distance],
            age: permitted_params[:age],
            surface:,
            condition: permitted_params[:condition],
            time: permitted_params[:time],
            purse: permitted_params[:purse],
            horses: permitted_params[:horses]
          )
          error!({ error: "invalid", detail: result.error }, 500) unless result.created?

          { race_result_id: result.race_result&.id }
        end
      end
    end
  end
end

