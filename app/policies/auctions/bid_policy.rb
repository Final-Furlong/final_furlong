module Auctions
  class BidPolicy < AuthenticatedPolicy
    class Scope < ::ApplicationPolicy::Scope
      def resolve
        scope.where(bidder: user.stable)
      end
    end
  end
end

