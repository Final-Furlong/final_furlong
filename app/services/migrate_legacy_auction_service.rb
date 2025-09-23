class MigrateLegacyAuctionService # rubocop:disable Metrics/ClassLength
  attr_reader :legacy_auction

  def initialize(legacy_auction:)
    @legacy_auction = legacy_auction
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    auction = Auction.find_or_initialize_by(title: legacy_auction.Title)
    auction.start_time = from_game_time(legacy_auction.Start)
    auction.end_time = from_game_time(legacy_auction.End)
    auction.auctioneer = Account::Stable.find_by(legacy_id: legacy_auction.Auctioneer)
    auction.outside_horses_allowed = legacy_auction.AllowOutside
    auction.reserve_pricing_allowed = legacy_auction.AllowRes
    auction.spending_cap_per_stable = legacy_auction.SpendingCap if legacy_auction.SpendingCap > 0
    auction.horse_purchase_cap_per_stable = legacy_auction.PerPerson if legacy_auction.PerPerson > 0
    auction.hours_until_sold = legacy_auction.SellTime.to_i
    status = legacy_auction.AllowStatus
    auction.racehorse_allowed_2yo = status.include?("2yo")
    auction.racehorse_allowed_3yo = status.include?("3yo")
    auction.racehorse_allowed_older = status.include?("4yo+")
    auction.stallion_allowed = status.include?("Stud")
    auction.broodmare_allowed = status.include?("Mare")
    auction.yearling_allowed = status.include?("Yearling")
    auction.weanling_allowed = status.include?("Weanling")
    auction.save
  rescue => e
    Rails.logger.error "Legacy Info: #{legacy_auction.inspect}"
    raise e
  end

  private

  def from_game_time(value)
    value - 4.years
  end
end

