class Daily::DeleteEmptyAuctionsJob < ApplicationJob
  queue_as :low_priority

  def perform
    tomorrow = Date.current + 1.day
    Auction.where(start_time: tomorrow.all_day).order(created_at: :asc).find_each do |auction|
      Auctions::DeleteEmptyAuctionService.call(auction:)
    end
  end
end

