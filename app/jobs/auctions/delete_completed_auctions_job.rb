class Auctions::DeleteCompletedAuctionsJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  queue_as :latency_30s

  good_job_concurrency_rule(
    label: -> { arguments.first[:id] },
    enqueue_limit: 1,
    perform_limit: 1
  )

  def perform(id:)
    return if run_today?
    auction = Auction.find(id)
    return unless auction.persisted?

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

