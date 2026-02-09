module Api
  module V1
    class RaceResults < Grape::API
      include Api::V1::Defaults

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ messages: e.full_messages }, 400)
      end

      resource :race_results do
        desc "Create a race result"
        params do
          requires :date, type: String, desc: "Date of the race"
          requires :number, type: Integer, desc: "Number of the race", values: 1..50
          requires :race_type, type: String, desc: "Race Type", values: Config::Racing.all_types
          requires :distance, type: Float, desc: "Distance", values: 5.0..24.00
          requires :age, type: String, desc: "Race age", values: Config::Racing.ages
          requires :track_name, type: String, desc: "Track Name"
          requires :track_surface, type: String, values: %w[dirt turf steeplechase], desc: "Track surface"
          requires :condition, type: String, desc: "Track condition", values: Config::Racing.conditions.map(&:downcase)
          requires :time, type: Float, desc: "Time in seconds"
          requires :purse, type: Integer, desc: "Purse", values: 10_000..25_000_000
          optional :male_only, type: Boolean, default: false, desc: "Male only flag"
          optional :female_only, type: Boolean, default: false, desc: "Female only flag"
          optional :grade, type: String, desc: "Race Grade", values: Config::Racing.grades
          optional :claiming_price, Integer, desc: "Claiming Price"
          optional :name, String, desc: "Race Name"
          requires :horses, type: Array, length: { min: 1, max: 14 } do
            requires :finish_position, type: Integer, desc: "Finish Position", values: 1..14
            requires :post_parade, type: Integer, desc: "Post Position", values: 1..14
            requires :positions, type: String, desc: "Positions"
            requires :margins, type: String, desc: "Margins"
            requires :fractions, type: String, desc: "Fractions"
            requires :legacy_id, type: Integer, desc: "Legacy ID", values: 1..10_000_000
            requires :jockey_legacy_id, type: Integer, desc: "Jockey Legacy ID", values: 1..10_000_000
            requires :odds, type: String, desc: "Odds"
            requires :weight, type: Integer, desc: "Weight", values: 10..200
            requires :speed_factor, type: Integer, desc: "Speed Factor", values: 0..1_000
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
            male_only: permitted_params[:male_only],
            female_only: permitted_params[:female_only],
            grade: permitted_params[:grade],
            claiming_price: permitted_params[:claiming_price],
            name: permitted_params[:name],
            horses: permitted_params[:horses]
          )
          error!({ error: "invalid", detail: result.error }, 500) unless result.created?

          { race_result_id: result.race_result&.id }
        end
      end
    end
  end
end

