class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  def perform(bidder, auction)
    Auctions::Bid.where(bidder:, auction:).current_high_bid.sale_time_met.each do |bid|
      Auctions::HorseSeller.new.process_sale(bid:)
    end
  end
end

