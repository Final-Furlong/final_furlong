class Daily::DeleteCompletedAuctionsJob < ApplicationJob
  queue_as :low_priority

  def perform(auction:)
    return if run_today?

    return if DateTime.current < auction.end_time

    result = Auctions::DeleteCompletedAuctionService.call(auction:)
    outcome = if result
      { deleted: true, auction_id: auction.id }
    else
      { deleted: false, auction_id: auction.id }
    end
    store_job_info(outcome:)
  end
end

