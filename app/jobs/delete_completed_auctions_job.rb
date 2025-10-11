class DeleteCompletedAuctionsJob < ApplicationJob
  queue_as :low_priority

  def perform(auction:)
    return if DateTime.current < auction.end_time

    Auctions::DeleteCompletedAuctionService.call(auction:)
  end
end

