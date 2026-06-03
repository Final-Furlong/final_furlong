class Auctions::TriggerSalesProcessingJob < ApplicationJob
  queue_as :latency_30s

  def perform
    Auction.current.find_each do |auction|
      Auctions::ProcessSalesJob.set(good_job_labels: [auction.id]).perform_later(auction)
    end
  end
end

