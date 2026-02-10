module Auctions
  class BidIncrementor < ApplicationService
    def increment_bid(bid_params)
      original_bid = Auctions::Bid.find_by(id: bid_params[:original_bid_id])
      new_bidder = Account::Stable.find_by(id: bid_params[:new_bidder_id])
      return Result.new(created: false, current_bid: nil) if original_bid.bidder == new_bidder

      ActiveRecord::Base.transaction do
        new_current_bid = [bid_params[:current_bid].to_i, bid_params[:maximum_bid].to_i].max
        if bid_params[:maximum_bid] && bid_params[:maximum_bid] == original_bid[:maximum_bid]
          new_current_bid = original_bid[:maximum_bid] - Config::Auctions.minimum_increment
          new_maximum_bid = original_bid[:maximum_bid]
        else
          current_bid_from_max = original_bid.maximum_bid + Config::Auctions.minimum_increment if original_bid.maximum_bid
          new_current_bid = current_bid_from_max if current_bid_from_max && bid_params[:maximum_bid].to_i > current_bid_from_max
          new_maximum_bid = bid_params[:maximum_bid].to_i if bid_params[:maximum_bid].to_i >= new_current_bid
        end
        original_bid.update(current_high_bid: false)
        Auctions::Bid.create!(
          auction: original_bid.auction,
          horse: original_bid.horse,
          bidder: new_bidder,
          current_bid: new_current_bid,
          maximum_bid: new_maximum_bid.presence,
          notify_if_outbid: false,
          created_at: 1.second.ago,
          updated_at: 1.second.ago
        )
        update_current_bid = if original_bid.maximum_bid && (new_maximum_bid == original_bid.maximum_bid || new_current_bid == original_bid.maximum_bid)
          original_bid.maximum_bid
        else
          new_current_bid + Config::Auctions.minimum_increment
        end
        update_old_bids(auction: original_bid.auction, horse: original_bid.horse)
        bid = Auctions::Bid.create!(
          auction: original_bid.auction,
          horse: original_bid.horse,
          bidder: original_bid.bidder,
          current_bid: update_current_bid,
          maximum_bid: original_bid.maximum_bid,
          notify_if_outbid: false,
          updated_at: Time.current,
          current_high_bid: true
        )
        return Result.new(created: true, current_bid: bid)
      end
    rescue ActiveRecord::ActiveRecordError
      Result.new(created: false, current_bid: nil)
    end

    class Result
      attr_reader :current_bid

      def initialize(created:, current_bid:)
        @created = created
        @current_bid = current_bid
      end

      def created?
        @created
      end
    end

    private

    def update_old_bids(auction:, horse:)
      Auctions::Bid.where(auction:, horse:, updated_at: ..Time.current).find_each do |bid|
        bid.update(current_high_bid: false)
      end
    end
  end
end

