module Racing
  class FutureRaceEntryPolicy < ApplicationPolicy
    include Dry::Monads[:result]

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope
      end
    end

    def index?
      manager?
    end

    def show?
      return false if record.date < Date.current

      manager?
    end

    def new?
      return false unless logged_in?
      return false if record.date < Date.current
      race = record.race
      current_entries = Horses::Horse.racehorse.managed_by(stable).joins(:race_entries).where(race_entries: { race: }).count
      if current_entries == race.entry_limit && race.entry_limit < race.last_day_entry_limit
        scheduled_horses_count = Horses::Horse.racehorse.managed_by(stable).joins(:future_race_entries).where(future_race_entries: { race: }).count
        return true if scheduled_horses_count < (race.last_day_entry_limit - race.entry_limit)
      end
      return false if Date.current >= race.entry_open_date

      true
    end

    def create?
      return false unless logged_in?
      return false if record.race.date < Date.current
      race = record.race
      return false if race.future_entries.where(horse: Horses::Horse.racehorse.managed_by(stable)).count >= race.last_day_entry_limit

      horse = record.horse
      return true unless horse
      return false unless horse.racehorse?
      return false unless manager?
      return false if horse.future_race_entries.exists?(date: record.race.date)
      return false if horse.future_race_entries.count >= Config::Racing.future_race_limit
      current_entries = Horses::Horse.racehorse.managed_by(stable).joins(:race_entries).where(race_entries: { race: }).count
      pd current_entries
      if current_entries == race.entry_limit && race.entry_limit < race.last_day_entry_limit
        scheduled_horses_count = Horses::Horse.racehorse.managed_by(stable).joins(:future_race_entries).where(future_race_entries: { race: }).count
        pd scheduled_horses_count
        return true if scheduled_horses_count < (race.last_day_entry_limit - race.entry_limit)
      end

      Date.current < race.entry_open_date
    end

    def edit?
      return false unless logged_in?
      return false if record.date < Date.current
      race = record.race
      return false if Date.current >= race.entry_open_date

      horse = record.horse
      return true unless horse
      return false unless horse.racehorse?

      manager?
    end

    def update?
      edit?
    end

    def destroy?
      return false unless logged_in?
      return false if Racing::RaceResult.exists?(date: record.race.date, number: record.race.number)

      manager?
    end

    private

    def manager?
      record.horse.manager == stable
    end
  end
end

