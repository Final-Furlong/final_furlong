class Auctions::ProcessSalesJob < ApplicationJob
  queue_as :default

  limits_concurrency to: 1, key: ->(auction) { auction }, duration: 5.minutes

  def perform(auction)
    horses = []
    outcome = {}
    Auctions::Horse.where(auction_id: auction.id).where.associated(:bids).distinct.each do |ah|
      next if ah.sold_at.present?
      wb = ah.bids.current_high_bid.first
      if wb.nil?
        wb = ah.bids.winning.first
        wb.update(current_high_bid: true)
      end
      next unless wb.bid_at < Time.current - auction.hours_until_sold.hours

      horses << { id: ah.id, bid_id: wb.id, time: wb.bid_at }
    end
    if horses.present?
      sorted_horses = horses.sort_by { |h| h[:time] }

      succeeded = false
      sold_horses = 0
      error = nil
      sorted_horses.each do |horse_info|
        winning_bid = Auctions::Bid.find(horse_info[:bid_id])
        result = Auctions::HorseSeller.new.process_sale(bid: winning_bid)
        if result.sold?
          sold_horses += 1
        else
          error = result.error
        end
        succeeded = result.sold?
      end
      outcome = if succeeded
        { auction_id: auction.id, sold_horses: }
      else
        { sold: false, error: }
      end
    else
      outcome = { sold: false, error: "No horses" }
    end
    store_job_info(outcome:)
    schedule_next_sales_job(auction:) unless Rails.env.test?
  end

  private

  def schedule_next_sales_job(auction:)
    return unless auction.horses.unsold.exists?

    next_updated_at = if auction.bids.current_high_bid.sale_time_not_met.exists?
      Auctions::Bid.where(auction:).current_high_bid.sale_time_not_met.minimum(:bid_at)
    else
      5.minutes.ago
    end
    next_updated_at = if next_updated_at > auction.end_time
      auction.end_time - 5.minutes
    else
      next_updated_at + auction.hours_until_sold.hours
    end
    Auctions::ProcessSalesJob.set(wait_until: next_updated_at).perform_later(auction) unless Time.current > next_updated_at
  end
end

