module CurrentStable
  class HorsePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Horses::HorsesQuery.new.owned_by(user.stable).living
      end
    end

    def show?
      record.owner == user&.stable
    end
  end
end

