class Daily::DeleteEmptyAuctionsJob < ApplicationJob
  queue_as :low_priority

  def perform
    return if run_today?

    tomorrow = Date.current + 1.day
    deleted_count = 0
    Auction.where(start_time: tomorrow.all_day).order(created_at: :asc).find_each do |auction|
      result = Auctions::DeleteEmptyAuctionService.call(auction:)
      deleted_count += 1 if result
    end
    outcome = if deleted_count.positive?
      { deleted: true, count: deleted_count }
    else
      { deleted: false }
    end
    store_job_info(outcome:)
  end
end

