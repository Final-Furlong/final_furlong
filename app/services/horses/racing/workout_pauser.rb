module Horses
  module Racing
    class WorkoutPauser
      attr_reader :options, :horse, :result

      def pause_workouts(horse:, date:)
        @horse = horse
        @options = horse.race_options

        @result = Result.new(options:)
        options.rest_date_for_workouts = (date.presence)

        result.saved = options.valid? && options.save
        result.options = options
        result
      end

      class Result
        attr_accessor :error, :saved, :options

        def initialize(options:, saved: false, error: nil)
          @saved = saved
          @options = options
          @error = nil
        end

        def saved?
          @saved
        end
      end
    end
  end
end

