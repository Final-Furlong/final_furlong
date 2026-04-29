module CurrentStable
  class FoalPolicy < ::ApplicationPolicy
    def create?
      return false unless record.broodmare?
      return false unless record.age >= Config::Breedings.min_age
      return false if record.next_foal
      return false unless manager?

      true
    end

    private

    def manager?
      record.manager == stable
    end
  end
end

