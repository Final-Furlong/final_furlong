module Horses
  class HorsePolicy < ::ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Horses::Horse.born
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
      return false if record.broodmare? && record.foals.exists?
      return false if record.stud? && record.foals.exists?
      return true if admin?
      return false if record.age > Config::Horses.max_rename_age && record.name.present?
      return false if record.age > Config::Horses.max_rename_age && !record.created?

      record.owner_id == stable&.id
    end

    def update?
      edit_name? || CurrentStable::HorsePolicy.new(user, record).geld?
    end

    def view_highlights?
      return false unless logged_in?

      !record.foal?
    end

    private

    def manager?
      record.manager_id == stable&.id
    end
  end
end

