module Horses
  class HorsePolicy < ::ApplicationPolicy
    scope_for :active_record_relation do |relation|
      Horses::HorsesRepository.new(scope: relation).born
    end

    def index?
      true
    end

    def show?
      !record.unborn?
    end
  end
end

