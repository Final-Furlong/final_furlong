class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  def perform(auction)
    horses = []
    Auctions::Horse.where(auction:).where.associated(:bids).distinct.each do |ah|
      next if ah.sold_at.present?
      wb = ah.bids.current_high_bid.first
      next unless wb.bid_at < Time.current - auction.hours_until_sold.hours

      horses << { id: ah.id, bid_id: wb.id, time: wb.bid_at }
    end
    sorted_horses = horses.sort_by { |h| h[:time] }

    sorted_horses.each do |horse_info|
      winning_bid = Auctions::Bid.find(horse_info[:bid_id])
      Auctions::HorseSeller.new.process_sale(bid: winning_bid)
    end
  end
end

