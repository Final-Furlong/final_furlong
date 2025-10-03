module Horses
  class HorsePolicy < ::ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Horses::HorsesQuery.new.born
      end
    end

    def index?
      true
    end

    def show?
      !record.unborn?
    end

    def image?
      show?
    end

    def thumbnail?
      show?
    end
  end
end

