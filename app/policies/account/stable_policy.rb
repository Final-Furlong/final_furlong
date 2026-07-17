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

    def send_private_message?
      return false unless logged_in?
      return false if record.user.discourse_id.blank?

      record != stable
    end

    def nominate_breeders_cup?
      return false unless logged_in?
      return false unless record == stable

      Horses::Horse::Foal.weanling.active.managed_by(Current.stable).joins(sire: :nominations).where(sire: { stud_breeders_cup_nominations: { year: Date.current.year } }).where.missing(:breeders_cup_nomination).exists?
    end
  end
end

