class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  def perform(bidder, auction)
    Auctions::Bid.where(bidder:, auction:).current_high_bid.sale_time_met.each do |bid|
      winning_bid = Auctions::Bid.where(auction:, horse: bid.horse).sale_time_met.winning.first
      if bid.id == winning_bid.id
        Auctions::HorseSeller.new.process_sale(bid:)
      end
    end
  end
end

