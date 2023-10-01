module Horses
  class RacehorsesQuery
    module Scopes
      def all_racehorses
        where(status: Status::STATUSES[:racehorse])
      end

      def without_training_schedules
        where.missing(:training_schedule)
      end

      def with_training_schedule(schedule)
        joins(:training_schedule).where(training_schedule: { id: schedule })
      end
    end

    def query
      @query ||= Horse.extending(Scopes)
    end

    delegate :all_racehorses, to: :query

    def without_training_schedules
      query.all_racehorses.without_training_schedules
    end

    def with_training_schedule(schedule)
      query.all_racehorses.with_training_schedule(schedule)
    end
  end
end

