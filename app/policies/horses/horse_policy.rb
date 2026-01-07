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

    def edit_name?
      return false if record.deceased?
      return false if record.unborn?
      return false if record.race_result_finishes.exists?
      return false if record.foals.exists?
      return false if record.stud_foals.exists?
      return false if record.age >= 2 && record.name.present?
      return true if admin?
      return false if record.age >= 2 && !record.created?

      record.owner == stable
    end

    def update?
      edit_name?
    end

    private

    def manager?
      record.manager == stable
    end
  end
end

