module Dashboard
  module Stable
    class Auction
      attr_reader :query, :auctions, :pagy

      DEFAULT_SORT = "created_at desc".freeze

      def initialize(query:, bids:, pagy:, query_result:)
        @query = query
        @query_result = query_result
        @bids = bids
        @auctions = ::Auction.joins(:bids).where(bids:).uniq + ::Auction.where(auctioneer: Current.stable)
        @pagy = pagy
      end

      def horse_counts(auction)
        hash = { selling: {}, buying: {} }
        auction.bids.includes(horse: :horse).where(bidder: Current.stable).find_each do |bid|
          hash[:buying][bid.horse_id] ||= {}
          horse = bid.horse
          hash[:buying][bid.horse_id][:horse_name] = horse.horse.name
          hash[:buying][bid.horse_id][:horse_slug] = horse.horse.slug
          hash[:buying][bid.horse_id][:auction_horse_id] = horse.id
          hash[:buying][bid.horse_id][:status] = horse.sold? ? :sold : :unsold
          current_bid = auction.bids.where(bidder: Current.stable, horse:).current_high_bid
          hash[:buying][bid.horse_id][:current_high_bid] = current_bid.exists?
          if current_bid.exists?
            current_bid = current_bid.first
            hash[:buying][bid.horse_id][:current_bid] = current_bid.current_bid
            hash[:buying][bid.horse_id][:maximum_bid] = current_bid.maximum_bid
            hash[:buying][bid.horse_id][:current_bidder] = current_bid.bidder.name
            hash[:buying][bid.horse_id][:state] = horse.sold? ? :sold : :pending
          else
            current_bid = auction.bids.where(horse:).current_high_bid.first
            hash[:buying][bid.horse_id][:current_bid] = current_bid.current_bid
            hash[:buying][bid.horse_id][:current_bidder] = current_bid.bidder.name
            hash[:buying][bid.horse_id][:state] = :lost
            hash[:buying][bid.horse_id][:bid_at] = current_bid.bid_at
          end
        end
        auction.horses.includes(:horse).where(seller: Current.stable).find_each do |horse|
          hash[:selling][horse.id] ||= {}
          hash[:selling][horse.id][:horse_name] = horse.horse.name
          hash[:selling][horse.id][:horse_slug] = horse.horse.slug
          hash[:selling][horse.id][:auction_horse_id] = horse.id
          hash[:selling][horse.id][:state] = horse.sold? ? :sold : :unsold
          current_bid = horse.bids.current_high_bid.first
          if current_bid
            hash[:selling][horse.id][:current_bid] = current_bid.current_bid
            hash[:selling][horse.id][:current_bidder] = current_bid.bidder.name
            hash[:selling][horse.id][:bid_at] = horse.bids.current_high_bid.first&.bid_at
            hash[:selling][horse.id][:state] = horse.sold? ? :sold : :pending
          else
            hash[:selling][horse.id][:state] = :unsold
          end
        end
        hash
      end

      def racetracks
        @racetracks ||= ::Racing::Racetrack.includes(:location).all
      end
    end
  end
end

