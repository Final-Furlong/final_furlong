module Horses
  class HorsePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        Horses::HorsesRepository.new(scope:).born
      end
    end

    def index?
      true
    end

    def show?
      !record.unborn?
    end
  end
end

