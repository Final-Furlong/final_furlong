class AuctionPolicy < ::ApplicationPolicy
  def index?
    true
  end

  def show?
    index?
  end

  def new?
    user.stable.auctions.upcoming.count <= Auction::MAX_AUCTIONS_PER_STABLE
  end

  def create?
    new?
  end
end

