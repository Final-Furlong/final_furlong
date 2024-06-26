module Horses
  class HorsePolicy < ::ApplicationPolicy
    scope_for :active_record_relation do |_relation|
      Horses::HorsesQuery.new.born
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
  end
end

