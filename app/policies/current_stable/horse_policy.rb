module CurrentStable
  class HorsePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope = Horses::HorsesRepository.new(scope:).owned_by(user.stable)
        Horses::HorsesRepository.new(scope:).living
      end
    end
  end
end

