class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  limits_concurrency to: 1, key: ->(args) { args[:bid].bidder_id }, duration: 5.minutes

  def perform(bid:, horse:)
    return if horse.sold?

    auction = bid.auction
    winning_bid = Auctions::Bid.winning.find_by(auction:, horse:)
    if winning_bid && winning_bid != bid
      Auctions::ProcessSalesJob.set(wait: 1.minute).perform_later(bid: winning_bid, horse:)
      return
    end

    Auctions::HorseSeller.new.process_sale(bid: winning_bid)
  end
end

