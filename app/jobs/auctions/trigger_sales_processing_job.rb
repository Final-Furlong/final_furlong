class Auctions::TriggerSalesProcessingJob < ApplicationJob
  queue_as :latency_30s

  def perform
    Auctions::Horse.counter_culture_fix_counts
    Auction.current.find_each do |auction|
      run_sales_job(auction:)
      schedule_next_sales_job(auction:)
    end
  end

  private

  def run_sales_job(auction:)
    return unless auction.pending_sales_count.positive?

    Auctions::ProcessSalesJob.set(good_job_labels: [auction.id], wait: 5.seconds).perform_later(auction)
  end

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
    return if next_updated_at < Time.current + 5.minutes

    Auctions::ProcessSalesJob.set(good_job_labels: [auction.id], wait_until: next_updated_at).perform_later(auction) unless Time.current > next_updated_at
  end
end
