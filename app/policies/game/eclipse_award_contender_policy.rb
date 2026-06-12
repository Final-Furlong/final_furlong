module Game
  class EclipseAwardContenderPolicy < ::ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where('voting_starts_at < ?', Time.current).where('voting_ends_at > ?', Time.current)
      end
    end
  end
end
