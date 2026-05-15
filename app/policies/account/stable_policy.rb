module Account
  class StablePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.joins(:user).merge(Account::User.active).not_color_war.not_game
      end
    end

    def index?
      true
    end

    def edit?
      record.user == user
    end

    def update?
      edit?
    end

    def show?
      true
    end

    def impersonate?
      admin? && record.user != user
    end

    def show_alerts?
      record.user == user
    end

    def nominate_breeders_cup?
      return false unless logged_in?

      Horses::Horse.weanling.managed_by(Current.stable).joins(sire: :stud_nominations).where(sire: { stud_breeders_cup_nominations: { year: Date.current.year } }).where.missing(:breeders_cup_nomination).exists?
    end
  end
end

