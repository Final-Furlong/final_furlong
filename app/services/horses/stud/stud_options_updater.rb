module Horses
  module Stud
    class StudOptionsUpdater
      attr_reader :options, :horse, :result

      def update_options(options:, params:)
        @options = options
        @horse = options.stud

        @result = Result.new(options:)
        options.approval_required = params[:approval_required].to_i.positive?
        options.breed_to_game_mares = params[:breed_to_game_mares].to_i.positive?
        options.outside_mares_allowed = params[:outside_mares_allowed].to_i
        options.outside_mares_per_stable = params[:outside_mares_per_stable].to_i
        unless horse.breedings.current_year.exists?
          options.stud_fee = params[:stud_fee].to_i
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

