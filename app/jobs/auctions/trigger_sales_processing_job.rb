class Auctions::TriggerSalesProcessingJob < ApplicationJob
  queue_as :latency_30s

  def perform
    Auction.current.find_each do |auction|
      Auctions::ProcessSalesJob.perform_later(auction)
    end
  end
end

