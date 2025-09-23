class MigrateLegacyAuctionHorseService # rubocop:disable Metrics/ClassLength
  attr_reader :legacy_auction, :legacy_auction_horse, :legacy_horse

  def initialize(legacy_auction:, legacy_auction_horse:)
    @legacy_auction = legacy_auction
    @legacy_auction_horse = legacy_auction_horse
    @legacy_horse = Legacy::Horse.find_by(id: legacy_auction_horse.Horse)
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    auction = MigrateLegacyAuctionService.call(legacy_auction:)
    MigrateLegacyHorseService.call(legacy_horse:)
    horse = Horses::Horse.find_by(legacy_horse.ID)
    auction_horse = AuctionHorse.find_or_initialize_by(auction:, horse:)
    auction_horse.max_price = legacy_auction_horse.Max if legacy_auction_horse.Max > 0
    auction_horse.reserve_price = legacy_auction_horse.Reserve if legacy_auction_horse.Reserve > 0
    auction_horse.comment = legacy_auction_horse.Comment if legacy_auction_horse.Comment.present?
    auction_horse.sold_at = Time.current if legacy_auction_horse.Sold
    auction_horse.save
  rescue => e
    Rails.logger.error "Legacy Info: #{legacy_auction_horse.inspect}"
    raise e
  end
end

