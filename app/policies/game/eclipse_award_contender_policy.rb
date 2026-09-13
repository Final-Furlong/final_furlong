module Game
  class EclipseAwardContenderPolicy < ::ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(voting_starts_at: ...Time.current).where("voting_ends_at > ?", Time.current)
      end
    end

    def vote?
      return false if Time.current > record.voting_ends_at

      !Game::EclipseAwardVote.exists?(category: record.category, voter: stable)
    end
  end
end

