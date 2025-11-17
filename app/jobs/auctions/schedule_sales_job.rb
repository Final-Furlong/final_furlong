class Auctions::ScheduleSalesJob < ApplicationJob
  queue_as :default

  def perform
    Auction.current.find_each do |auction|
      stable_ids = []
      horses = auction.horses.where.associated(:bids).uniq
      horses.each do |horse|
        winning_bid = horse.bids.winning.first
        stable_ids << winning_bid.bidder_id
      end

      stable_ids.each do |id|
        unless job_exists?(auction.id, id)
          times = []
          Auctions::Bid.where(bidder: id, auction:).current_high_bid.each do |bid|
            winning_bid = Auctions::Bid.where(auction:, horse: bid.horse).sale_time_met.winning.first
            if bid == winning_bid
              times << bid.updated_at
            end
          end
          Auctions::ProcessSalesJob.set(wait_until: times.min).perform_later(bidder: id, auction:)
        end
      end
    end
  end

  private

  def job_exists?(auction_id, bidder_id)
    SolidQueue::Job.where(class_name: "Auctions::ProcessSalesJob")
      .where("arguments LIKE ?", "%#{bidder_id}%")
      .exists?(["arguments LIKE ?", "%#{auction_id}%"])
  end
end

