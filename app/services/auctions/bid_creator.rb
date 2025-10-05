module Auctions
  class BidCreator < ApplicationService
    attr_reader :auction_horse

    def create_bid(bid_params)
      auction = Auction.find_by(id: bid_params[:auction_id])
      result = Result.new(created: false, auction: nil, bid: nil, horse: nil, error: nil)
      unless auction
        result.error = error("auction_not_found")
        return result
      end
      result.auction = auction

      unless auction.active?
        result.error = error("auction_inactive")
        return result
      end

      @auction_horse = Auctions::Horse.find_by(auction:, horse_id: bid_params[:horse_id])
      unless auction_horse
        result.error = error("horse_not_found")
        return result
      end
      result.horse = auction_horse

      if auction_horse.sold?
        result.error = error("horse_sold")
        return result
      end

      bidder = Account::Stable.find_by(id: bid_params[:bidder_id])
      unless bidder
        result.error = error("bidder_not_found")
        return result
      end

      if bid_params[:bidder_id] == Horses::Horse.where(id: auction_horse.horse_id).pick(:owner_id)
        result.error = error("bidder_is_owner")
        return result
      end

      if bid_params[:bidder_id] == previous_bid&.bidder_id
        result.error = error("bidder_has_high_bid")
        return result
      end

      max_bid = previous_max_bid
      minimum_bid_amount = max_bid + Auctions::Bid::MINIMUM_INCREMENT if max_bid.positive?
      if minimum_bid_amount && bid_params[:current_bid] <= minimum_bid_amount
        Auctions::BidIncrementor.new.increment_bid(
          original_bid_id: previous_bid.id, new_bidder_id: bid_params[:bidder_id],
          current_bid: bid_params[:current_bid], maximum_bid: bid_params[:maximum_bid]
        )
        result.error = I18n.t("services.auctions.bid_creator.bid_not_high_enough", number: minimum_bid_amount)
        return result
      end

      result.error = nil
      bid = Auctions::Bid.new(
        auction:,
        horse: auction_horse,
        bidder:,
        current_bid: bid_params[:current_bid],
        maximum_bid: bid_params[:maximum_bid].presence,
        comment: bid_params[:comment],
        email_if_outbid: false
      )

      if bid.valid?
        result.created = bid.save
      else
        result.error = bid.errors.full_messages.to_sentence
      end
      result.bid = bid
      result
    end

    def previous_bid
      @previous_bid ||= Auctions::Bid.where(horse: auction_horse)
        .order(maximum_bid: :desc, current_bid: :desc, updated_at: :desc).first
    end

    def previous_max_bid
      return 0 unless previous_bid

      [previous_bid.current_bid.to_i, previous_bid.maximum_bid.to_i].max
    end

    def error(key)
      I18n.t("services.auctions.bid_creator.#{key}")
    end

    class Result
      attr_reader :auction, :bid, :horse, :error

      def initialize(created:, auction:, horse:, bid:, error: nil)
        @created = created
        @auction = auction
        @bid = bid
        @horse = horse
        @error = error
      end

      attr_writer :auction

      attr_writer :horse

      attr_writer :bid

      attr_writer :error

      attr_writer :created

      def created?
        @created
      end
    end
  end
end

