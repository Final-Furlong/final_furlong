module Auctions
  class BidDeleter < ApplicationService
    attr_reader :auction_horse

    def delete_bids(bids:)
      horse = bids.first.horse
      ActiveRecord::Base.transaction do
        bids.map(&:destroy!)

        if Auctions::Bid.winning.exists?(horse:)
          previous_bid = Auctions::Bid.winning.find_by!(horse:)
          previous_bid.update(bid_at: Time.current, current_high_bid: true)
        end
      end
      Result.new(deleted: true, bids:, error: nil)
    rescue ActiveRecord::ActiveRecordError
      Result.new(deleted: false, bids:, error: nil)
    end

    class Result
      attr_accessor :deleted, :bids, :error

      def initialize(deleted:, bids:, error: nil)
        @deleted = deleted
        @bids = bids
        @error = error
      end

      def deleted?
        @deleted
      end
    end
  end
end

