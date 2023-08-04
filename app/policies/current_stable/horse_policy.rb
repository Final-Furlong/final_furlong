module CurrentStable
  class HorsePolicy < ApplicationPolicy
    scope_for :relation do |relation|
      relation = Horses::HorsesRepository.new(scope: relation).owned_by(user.stable)
      Horses::HorsesRepository.new(scope: relation).living
    end
  end
end

