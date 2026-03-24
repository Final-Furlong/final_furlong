module CurrentStable
  class BoardingPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(horse: Horses::Horse.racehorse.managed_by(Current.stable))
      end
    end

    def index?
      stable.present?
    end

    def new?
      create?
    end

    def create?
      Horses::Horse.racehorse.managed_by(stable).where.missing(:current_boarding).present?
    end

    def update?
      return false unless record.horse.manager == stable

      record.current?
    end

    def list_current?
      Horses::Horse.racehorse.managed_by(stable).where.associated(:current_boarding).present?
    end

    def list_historical?
      Horses::Horse.racehorse.managed_by(stable).where.associated(:boardings).present?
    end
  end
end

