class AuctionPolicy < AuthenticatedPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
    end
  end

  def create?
    return false unless user&.stable

    user.stable.auctions.upcoming.count <= Auction::MAX_AUCTIONS_PER_STABLE
  end

  def update?
    return false unless user&.stable
    return true if admin?

    record.auctioneer == user.stable
  end

  def destroy?
    return false unless user&.stable
    return false unless (record.auctioneer == user.stable) || admin?

    record.start_time > Time.current
  end
end

