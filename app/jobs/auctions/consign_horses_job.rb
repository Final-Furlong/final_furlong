class Auctions::ConsignHorsesJob < ApplicationJob
  queue_as :low_priority

  class AuctionNotCreated < StandardError; end

  def perform(auction:)
    return if auction.auctioneer.name != "Final Furlong"

    Auctions::HorseConsigner.new.consign_horses(auction:)
  end
end

