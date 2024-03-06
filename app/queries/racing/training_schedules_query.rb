module Racing
  class TrainingSchedulesQuery
    module Scopes
      def with_stable(stable)
        where(stable:)
      end

      def ordered
        order(name: :asc)
      end
    end

    def query
      @query ||= TrainingSchedule.extending(Scopes)
    end

    delegate :with_stable, to: :query

    delegate :ordered, to: :query
  end
end

