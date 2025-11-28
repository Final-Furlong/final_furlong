module Horses
  module Racing
    class RaceOptionsUpdater
      attr_reader :options, :horse, :result

      def update_options(options:, params:)
        @options = options
        @horse = options.horse

        @result = Result.new(options:)
        options.runs_on_dirt = params[:runs_on_dirt] if params[:runs_on_dirt]
        options.runs_on_turf = params[:runs_on_turf] if params[:runs_on_turf]
        options.trains_on_dirt = params[:trains_on_dirt] if params[:trains_on_dirt]
        options.trains_on_turf = params[:trains_on_turf] if params[:trains_on_turf]
        options.minimum_distance = params[:minimum_distance] if params[:minimum_distance]
        options.maximum_distance = params[:maximum_distance] if params[:maximum_distance]
        options.first_jockey = ::Racing::Jockey.active.find(params[:first_jockey]) if params[:first_jockey].present?
        options.second_jockey = ::Racing::Jockey.active.find(params[:second_jockey]) if params[:second_jockey].present?
        options.third_jockey = ::Racing::Jockey.active.find(params[:third_jockey]) if params[:third_jockey].present?
        options.racing_style = params[:racing_style] if params[:racing_style].present?
        if params[:note_for_next_race].present?
          options.note_for_next_race = params[:note_for_next_race]
          options.next_race_note_created_at = Time.current
        end
        options.blinkers = params.key?(:blinkers)
        options.shadow_roll = params.key?(:shadow_roll)
        options.wraps = params.key?(:wraps)
        options.figure_8 = params.key?(:figure_8)
        options.no_whip = params.key?(:no_whip)

        result.created = options.valid? && options.save
        result.options = options
        result
      end

      class Result
        attr_accessor :error, :created, :options

        def initialize(options:, created: false, error: nil)
          @created = created
          @options = options
          @error = nil
        end

        def created?
          @created
        end
      end
    end
  end
end

