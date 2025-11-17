class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  def perform(bidder, auction)
    Auctions::Bid.joins(:horse).where(bidder:, auction:).sale_time_met.merge(Auctions::Horse.unsold).each do |bid|
      winning_bid = Auctions::Bid.where(auction:, horse: bid.horse).sale_time_met.winning.first
      Auctions::HorseSeller.new.process_sale(bid: winning_bid)
    end
  end
end

