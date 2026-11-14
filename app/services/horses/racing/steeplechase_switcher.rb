module Horses
  module Racing
    class SteeplechaseSwitcher
      attr_reader :options, :horse, :result

      def switch_to_steeplechase(horse:)
        @horse = horse
        @options = horse.race_options

        @result = Result.new(options:)
        options.racehorse_type = "jump"
        if !options.first_jockey&.jump?
          options.first_jockey = nil
        end
        if !options.second_jockey&.jump?
          options.second_jockey = nil
        end
        if !options.third_jockey&.jump?
          options.third_jockey = nil
        end

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

