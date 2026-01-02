class AuctionPolicy < AuthenticatedPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
    end
  end

  def create?
    return false unless user&.stable

    user.stable.auctions.upcoming.count < Config::Auctions.max_auctions_per_stable
  end

  def update?
    return false unless user&.stable
    return false unless record.future?

    record.auctioneer == user.stable || admin?
  end

  def destroy?
    return false unless user&.stable
    return false unless (record.auctioneer == user.stable) || admin?

    record.start_time > Time.current
  end

  def allow_outside_horses?
    admin?
  end
end

