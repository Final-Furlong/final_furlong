module Horses
  class BoardingPolicy < ::ApplicationPolicy
    class Scope < ::ApplicationPolicy::Scope
      def resolve
        scope.all
      end
    end

    def new?
      create?
    end

    def create?
      return false if Horses::Boarding.current.exists?(horse: record.horse)

      record.horse.manager == stable
    end

    def destroy?
      return false unless record.current?

      record.horse.manager == stable
    end
  end
end

