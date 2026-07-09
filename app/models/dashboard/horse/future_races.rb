module Dashboard
  module Horse
    class FutureRaces
      attr_reader :horse, :params

      def initialize(horse:, params: {})
        @horse = horse
        @params = params
      end

      def current_entry_ids
        ::Racing::RaceEntry.where(horse: @horse).pluck(:race_id)
      end

      def future_entry_ids
        ::Racing::FutureRaceEntry.where(horse: @horse).pluck(:race_id)
      end

      def current_entry_dates
        ::Racing::RaceSchedule.where(id: current_entry_ids + future_entry_ids).select(:date).distinct
      end

      def count
        @count ||= query.result.count
      end

      def query
        return @query if defined?(@query)

        @query = ::Racing::RaceSchedule.where.not(date: current_entry_dates.map(&:date)).available_for_scheduling.for_age(@horse.age)
          .for_gender(@horse.gender)
          .for_race_options(@horse.race_options).for_race_qualification(@horse.race_qualification)
          .includes(track_surface: :racetrack)

        if @horse.in_transit?
          shipment = @horse.shipments.order(arrival_date: :desc).first
          @query = @query.where("date > ?", shipment.arrival_date)
        end

        if current_entry_ids.present?
          @query = @query.entries_not_yet_open
        end

        params[:q] ||= {}
        options = @horse.race_options
        case options.racehorse_type.to_s.downcase
        when "flat"
          if options.trains_on_dirt && !options.trains_on_turf
            params[:q][:track_surface_surface_eq] ||= "dirt"
          elsif options.trains_on_turf && !options.trains_on_dirt
            params[:q][:track_surface_surface_eq] ||= "turf"
          end
        when "jump"
          params[:q][:track_surface_surface_eq] ||= "steeplechase"
        end
        params[:q][:distance_gteq] ||= options.minimum_distance if options.minimum_distance > Config::Racing.minimum_distance
        params[:q][:distance_lteq] ||= options.maximum_distance if options.maximum_distance < Config::Racing.maximum_distance
        @gender = params[:q].delete(:gender) if params[:q]
        @query = case @gender
        when "open"
          @query.where(female_only: false, male_only: false)
        when "male"
          @query.where(male_only: true)
        when "female"
          @query.where(female_only: true)
        else
          @query
        end
        @query = @query.ransack(params[:q])
        @query.sorts = ["date asc", "race_type asc"] if @query.sorts.blank?
        @query
      end

      def existing_schedules
        @existing_schedules = ::Racing::RaceSchedule.where(id: future_entry_ids).pluck(:date)
      end

      def min_days
        @min_days = if ::Current.user.setting&.racing&.apply_minimums_for_future_races
          ::Current.user.setting&.racing&.min_days_delay_from_last_race.to_i
        else
          0
        end
      end
    end
  end
end

