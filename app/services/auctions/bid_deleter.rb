module Auctions
  class BidDeleter < ApplicationService
    attr_reader :auction_horse

    def delete_bids(bids:)
      horse = bids.first.horse
      ActiveRecord::Base.transaction do
        bids.map(&:destroy!)

        if Auctions::Bid.winning.exists?(horse:)
          previous_bid = Auctions::Bid.winning.where(horse:).first
          previous_bid&.update(updated_at: Time.current)
        end
      end
      Result.new(deleted: true, bids:, error: nil)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
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

