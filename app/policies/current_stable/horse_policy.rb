module CurrentStable
  class HorsePolicy < ApplicationPolicy
    scope_for :relation do |_relation|
      Horses::HorsesQuery.new.owned_by(user.stable).living
    end
  end
end

