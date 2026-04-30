module Racing
  class RaceSchedulePolicy < ApplicationPolicy
    include Dry::Monads[:result]

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope
      end
    end

    def index?
      logged_in?
    end

    def post_parade?
      logged_in? && !record.past?
    end

    def claim?
      return false unless logged_in?

      record.claiming_deadline >= Date.current
    end

    def enter?
      return false unless logged_in?
      return false if Racing::RaceResult.exists?(date: record.date, number: record.number)

      Date.current >= record.entry_open_date
    end

    def add_entry?
      add_entry_result.success?
    end

    def schedule?
      return false unless logged_in?
      return false if Racing::RaceResult.exists?(date: record.date, number: record.number)

      record.entry_open_date >= Date.current
    end

    def add_scheduled_entry?
      add_scheduled_entry_result.success?
    end

    def add_scheduled_entry_result
      return Failure(:cannot_schedule) unless schedule?
      horses_count = Horses::Horse.racehorse.managed_by(stable).joins(:future_race_entries).where(future_race_entries: { race: record }).count
      return Failure(:max_stable_entries) if horses_count >= record.entry_limit

      Success()
    end

    def add_entry_result
      return Failure(:cannot_enter) unless enter?
      return Failure(:race_full) if record.entries_count >= Config::Racing.entry_limit_overall
      horses_count = Horses::Horse.racehorse.managed_by(stable).joins(:race_entries).where(race_entries: { race: record }).count
      return Failure(:max_stable_entries) if horses_count >= record.entry_limit

      Success()
    end
  end
end

