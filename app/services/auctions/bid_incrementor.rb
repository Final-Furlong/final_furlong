module Auctions
  class BidIncrementor < ApplicationService
    def increment_bid(bid_params)
      original_bid = Auctions::Bid.find_by(id: bid_params[:original_bid_id])
      new_bidder = Account::Stable.find_by(id: bid_params[:new_bidder_id])
      return Result.new(created: false, current_bid: nil) if original_bid.bidder == new_bidder

      ActiveRecord::Base.transaction do
        new_current_bid = [bid_params[:current_bid].to_i, bid_params[:maximum_bid].to_i].max
        new_maximum_bid = bid_params[:maximum_bid].to_i if bid_params[:maximum_bid].to_i >= new_current_bid
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
          new_current_bid + Auctions::Bid::MINIMUM_INCREMENT
        end
        bid = Auctions::Bid.create!(
          auction: original_bid.auction,
          horse: original_bid.horse,
          bidder: original_bid.bidder,
          current_bid: update_current_bid,
          maximum_bid: original_bid.maximum_bid,
          notify_if_outbid: false,
          updated_at: Time.current
        )
        bid.unschedule_sale
        schedule_job(bid)
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

    def schedule_job(bid)
      Auctions::ProcessSalesJob.set(wait: bid.auction.hours_until_sold.hours).perform_later(
        bid:, horse: bid.horse, auction: bid.auction, bidder: bid.bidder
      )
    end
  end
end

