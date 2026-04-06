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
      return false if record.date >= Date.current

      logged_in?
    end

    def new?
      return false if record.date < Date.current
      return false if Date.current > record.race.entry_deadline

      logged_in?
    end

    def claim?
      claim_result.success?
    end

    def delete_claim?
      logged_in?
    end

    def claim_result
      return Failure(:not_logged_in) unless logged_in?
      return Failure(:deadline_past) unless record.race.claiming_deadline >= Date.current
      return Failure(:owns_horse) if record.horse.manager == stable
      return Failure(:current_claim) if record.claims.exists?(claimer: stable)
      return Failure(:another_claim) if Racing::Claim.exists?(race_date: record.race.date, claimer: stable)

      Success()
    end
  end
end

