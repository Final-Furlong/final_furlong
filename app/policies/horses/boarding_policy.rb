module Horses
  class BoardingPolicy < ::ApplicationPolicy
    class Scope < ::ApplicationPolicy::Scope
      def resolve
        scope.all
      end
    end

    def destroy?
      return false unless record.current?

      record.horse.manager == stable
    end
  end
end

