class Auctions::ConsignHorsesJob < ApplicationJob
  queue_as :low_priority

  class AuctionNotCreated < StandardError; end

  def perform(auction:)
    return if run_today?
    return if auction.auctioneer.name != "Final Furlong"

    result = Auctions::HorseConsigner.new.consign_horses(auction:)
    outcome = if result.created?
      { auction_id: result.auction.id, consigned: result.number_consigned }
    else
      { created: false, error: result.error }
    end
    store_job_info(outcome:)
  end
end

