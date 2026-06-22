class Auctions::TriggerSalesProcessingJob < ApplicationJob
  queue_as :latency_30s

  def perform
    Auctions::Horse.counter_culture_fix_counts
    Auction.current.find_each do |auction|
      run_sales_job(auction:)
      schedule_next_sales_job(auction:)
      schedule_deletion(auction:)
    end
  end

  private

  def schedule_deletion(auction:)
    return unless auction.ended?
    return if auction.pending_sales_count.positive?
    return if auction.horses.unsold.exists?

    Auctions::DeleteCompletedAuctionsJob.set(good_job_labels: [auction.id], wait: 30.seconds).perform_later(id: auction.id)
  end

  def run_sales_job(auction:)
    return unless auction.pending_sales_count.positive?

    Auctions::ProcessSalesJob.set(good_job_labels: [auction.id], wait: 5.seconds).perform_later(id: auction.id)
  end

  def schedule_next_sales_job(auction:)
    return if auction.pending_sales_count.positive?
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
    return if next_updated_at < 5.minutes.from_now

    Auctions::ProcessSalesJob.set(good_job_labels: [auction.id], wait_until: next_updated_at).perform_later(id: auction.id) unless Time.current > next_updated_at
  end
end

