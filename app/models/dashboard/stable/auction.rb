module Dashboard
  module Stable
    class Auction
      attr_reader :query, :auctions, :pagy

      def initialize(query:, auctions:, bids:, pagy:, query_result:)
        @query = query
        @query_result = query_result
        @bids = bids
        @auctions = auctions + ::Auction.where(auctioneer: Current.stable)
        @pagy = pagy
      end

      def total_horses_selling(auction)
        horse_counts(auction)[:selling].count
      end

      def total_horses_sold(auction)
        horse_counts(auction)[:selling].count { |key, horse| horse[:state] == :sold }
      end

      def total_sales_pending(auction)
        horse_counts(auction)[:selling].count { |key, horse| horse[:state] == :pending }
      end

      def total_horses_unsold(auction)
        horse_counts(auction)[:selling].count { |key, horse| horse[:state] == :unsold }
      end

      def total_money_in(auction)
        total_money = 0
        horse_counts(auction)[:selling].select { |key, horse| horse[:state] == :sold }
          .each { |key, horse| total_money += horse[:current_bid] }
        total_money
      end

      def total_money_pending(auction)
        total_money = 0
        horse_counts(auction)[:selling].select { |key, horse| horse[:state] == :pending }
          .each { |key, horse| total_money += horse[:current_bid] }
        total_money
      end

      def average_income_per_horse(auction)
        return 0 if (total_horses_sold(auction) + total_sales_pending(auction)).zero?

        (total_money_in(auction) + total_money_pending(auction)) / (total_horses_sold(auction) + total_sales_pending(auction))
      end

      def total_horses_bid(auction)
        horse_counts(auction)[:buying].count
      end

      def total_horses_won(auction)
        horse_counts(auction)[:buying].count { |key, horse| horse[:state] == :sold }
      end

      def total_horses_pending(auction)
        horse_counts(auction)[:buying].count { |key, horse| horse[:state] == :pending }
      end

      def total_horses_lost(auction)
        horse_counts(auction)[:buying].count { |key, horse| horse[:state] == :lost }
      end

      def total_money_spent(auction)
        total_spent = 0
        horse_counts(auction)[:buying].select { |key, horse| horse[:state] == :sold }
          .each { |key, horse| total_spent += horse[:current_bid] }
        total_spent
      end

      def total_max_bids(auction)
        total_spent = 0
        horse_counts(auction)[:buying].select { |key, horse| horse[:state] != :lost }
          .each { |key, horse| total_spent += horse[:maximum_bid].to_i }
        total_spent
      end

      def average_spend_per_horse(auction)
        return 0 if total_horses_won(auction).zero?

        total_money_spent(auction) / total_horses_won(auction)
      end

      def horse_counts(auction)
        hash = { selling: {}, buying: {} }
        auction.bids.includes(:bidder, horse: :horse).where(bidder: Current.stable).find_each do |bid|
          hash[:buying][bid.horse_id] ||= {}
          horse = bid.horse
          hash[:buying][bid.horse_id][:horse_name] = horse.horse.budget_name
          hash[:buying][bid.horse_id][:horse_gender] = horse.horse.gender
          hash[:buying][bid.horse_id][:horse_slug] = horse.horse.slug
          hash[:buying][bid.horse_id][:auction_horse_id] = horse.id
          hash[:buying][bid.horse_id][:status] = horse.sold? ? :sold : :unsold
          current_bid = auction.bids.includes(:bidder).where(bidder: Current.stable, horse:).current_high_bid
          hash[:buying][bid.horse_id][:current_high_bid] = current_bid.exists?
          if current_bid.exists?
            current_bid = current_bid.first
            hash[:buying][bid.horse_id][:current_bid] = current_bid.current_bid
            hash[:buying][bid.horse_id][:maximum_bid] = current_bid.maximum_bid
            hash[:buying][bid.horse_id][:current_bidder] = current_bid.bidder.name
            hash[:buying][bid.horse_id][:state] = horse.sold? ? :sold : :pending
            hash[:buying][bid.horse_id][:bid_at] = current_bid.bid_at
          else
            current_bid = auction.bids.includes(:bidder).where(horse:).current_high_bid.first
            last_bid = auction.bids.where(horse:, bidder: Current.stable).winning.first
            hash[:buying][bid.horse_id][:current_bid] = current_bid.current_bid
            hash[:buying][bid.horse_id][:current_bidder] = current_bid.bidder.name
            hash[:buying][bid.horse_id][:your_max] = [last_bid.current_bid, last_bid.maximum_bid.to_i].max
            hash[:buying][bid.horse_id][:state] = :lost
          end
          hash[:buying][bid.horse_id][:bid_at] = current_bid&.bid_at
        end
        auction.horses.includes(:horse).where(seller: Current.stable).find_each do |horse|
          hash[:selling][horse.id] ||= {}
          hash[:selling][horse.id][:horse_name] = horse.horse.budget_name
          hash[:selling][horse.id][:horse_gender] = horse.horse.gender
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

