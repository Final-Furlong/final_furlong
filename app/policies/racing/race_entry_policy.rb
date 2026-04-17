module Racing
  class RaceEntryPolicy < ApplicationPolicy
    include Dry::Monads[:result]

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope
      end
    end

    def index?
      logged_in?
    end

    def show?
      return false if record.date < Date.current

      logged_in?
    end

    def new?
      return false unless logged_in?
      return false if record.date < Date.current
      race = record.race
      return false if Date.current > race.entry_deadline

      Racing::RaceQualificationQuery.new(race:).qualified.exists?
    end

    def create?
      return false unless logged_in?
      return false if record.date < Date.current
      race = record.race
      return false if Date.current > race.entry_deadline
      return false if race.entries.where(horse: Horses::Horse.racehorse.managed_by(stable)).count >= race.entry_limit

      horse = record.horse
      return true unless horse
      return false unless horse.racehorse?

      horse.manager == stable
    end

    def edit?
      return false unless logged_in?
      return false if record.date < Date.current
      race = record.race
      return false if Racing::RaceResult.exists?(date: race.date, number: race.number)

      horse = record.horse
      return true unless horse
      return false unless horse.racehorse?

      horse.manager == stable
    end

    def update?
      scratch?
    end

    def scratch?
      return false unless logged_in?
      return false if Racing::RaceResult.exists?(date: record.race.date, number: record.race.number)

      record.horse.manager == stable
    end

    def claim?
      claim_result.success?
    end

    def delete_claim?
      logged_in?
    end

    def claim_result
      return Failure(:not_logged_in) unless logged_in?
      return Failure(:not_claiming_race) unless record.race.race_type == "claiming"
      return Failure(:deadline_past) unless record.race.claiming_deadline >= Date.current
      return Failure(:owns_horse) if record.horse.manager == stable
      return Failure(:current_claim) if record.claims.exists?(claimer: stable)
      return Failure(:another_claim) if Racing::Claim.exists?(race_date: record.race.date, claimer: stable)

      Success()
    end
  end
end

