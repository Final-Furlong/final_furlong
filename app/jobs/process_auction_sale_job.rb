class ProcessAuctionSaleJob < ApplicationJob
  queue_as :default

  limits_concurrency to: 1, key: ->(bidder) { bidder }, duration: 5.minutes

  def perform(bid:, horse:, auction:, bidder:)
    return if horse.sold?

    winning_bid = Auctions::Bid.winning.find_by(auction:, horse:)
    if winning_bid && winning_bid != bid
      ProcessAuctionSaleJob.set(wait: 1.minute).perform_later(bid: winning_bid, auction:, horse:, bidder: winning_bid.bidder)
      return
    end

    Auctions::HorseSeller.new.process_sale(bid: winning_bid)
  end
end

