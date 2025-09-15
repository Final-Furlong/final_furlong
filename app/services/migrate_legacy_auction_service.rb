class MigrateLegacyAuctionService # rubocop:disable Metrics/ClassLength
  attr_reader :legacy_auction

  def initialize(legacy_auction:)
    @legacy_auction = legacy_auction
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Location.find_or_create_by(name: "Arlington Heights, IL", state: "Illinois", country: "USA")
  rescue => e
    Rails.logger.error "Legacy Info: #{legacy_auction.inspect}"
    raise e
  end

  private
end

