class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  def perform(auction)
    Auctions::Bid.joins(:horse).where(auction:).sale_time_met.merge(Auctions::Horse.unsold).each do |bid|
      winning_bid = Auctions::Bid.where(auction:, horse: bid.horse).sale_time_met.current_high_bid.first
      Auctions::HorseSeller.new.process_sale(bid: winning_bid)
    end
  end
end

