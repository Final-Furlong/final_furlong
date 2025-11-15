class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  limits_concurrency key: ->(bidder) { bidder }, duration: 5.minutes

  def perform(bidder, auction)
    Auctions::Bid.where(bidder:, auction:).current_high_bid.sale_time_met.each do |bid|
      Auctions::HorseSeller.new.process_sale(bid:)
    end
  end
end

