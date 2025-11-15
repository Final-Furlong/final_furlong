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

      available_balance = bidder.available_balance.to_i
      if available_balance < bid_params[:current_bid].to_i || available_balance < bid_params[:maximum_bid].to_i
        result.error = error("cannot_afford_bid")
        return result
      end

      max_bid_amount = [bid_params[:current_bid], bid_params[:maximum_bid]].map(&:to_i).max
      increment = Auctions::Bid::MINIMUM_INCREMENT

      if (bid_params[:current_bid] % increment).positive? || (max_bid_amount % increment).positive?
        result.error = I18n.t("services.auctions.bid_creator.bid_value_invalid", increment:)
        return result
      end

      if bid_params[:bidder_id] == Horses::Horse.where(id: auction_horse.horse_id).pick(:owner_id)
        result.error = error("bidder_is_owner")
        return result
      end

      horse_reserve = auction_horse.reserve_price.to_i
      if horse_reserve.positive?
        if max_bid_amount < horse_reserve
          result.error = error("reserve_not_met")
          bid_params[:current_bid] = max_bid_amount
        elsif bid_params[:current_bid] < horse_reserve
          bid_params[:current_bid] = horse_reserve
        end
      end

      horse_max = auction.horse_purchase_cap_per_stable.to_i
      if horse_max.positive?
        if horses_bought(bid_params[:bidder_id]) >= horse_max
          result.error = error("bought_max_horses")
          return result
        end
      end

      money_max = auction.spending_cap_per_stable.to_i
      if money_max.positive?
        if money_spent(bid_params[:bidder_id]) + max_bid_amount > money_max
          result.error = error("spent_max_money")
          return result
        end
      end

      if bid_params[:bidder_id] == previous_bid&.bidder_id
        result.error = error("bidder_has_high_bid")
        return result
      end

      ActiveRecord::Base.transaction do
        max_bid = previous_max_bid
        minimum_bid_amount = max_bid + increment if max_bid.positive?
        if minimum_bid_amount && bid_params[:current_bid] <= minimum_bid_amount && bid_params[:maximum_bid].to_i <= minimum_bid_amount
          Auctions::BidIncrementor.new.increment_bid(
            original_bid_id: previous_bid.id, new_bidder_id: bid_params[:bidder_id],
            current_bid: bid_params[:current_bid], maximum_bid: bid_params[:maximum_bid]
          )
          extra_invalid_amount = bid_params[:current_bid] % increment
          minimum_display_amount = [previous_bid.current_bid + increment, bid_params[:current_bid] - extra_invalid_amount.to_i].max
          result.error = I18n.t("services.auctions.bid_creator.bid_not_high_enough", number: minimum_display_amount)
          return result
        end

        result.error = nil unless result.error == error("reserve_not_met")
        bid = Auctions::Bid.new(
          auction:,
          horse: auction_horse,
          bidder:,
          current_bid: bid_params[:current_bid],
          maximum_bid: bid_params[:maximum_bid].presence,
          comment: bid_params[:comment],
          notify_if_outbid: false
        )

        if bid.valid?
          result.created = bid.save
        else
          result.error = bid.errors.full_messages.to_sentence
        end
        result.bid = bid
      rescue ActiveRecord::ActiveRecordError
        result.created = false
        result.error = bid.errors.full_messages.to_sentence if bid
      end
      result
    end

    class Result
      attr_accessor :auction, :horse, :bid, :error, :created

      def initialize(created:, auction:, horse:, bid:, error: nil)
        @created = created
        @auction = auction
        @bid = bid
        @horse = horse
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def money_spent(bidder_id)
      money = 0
      Auctions::Horse.joins(:bids).where(bids: { bidder_id: }).sold.find_each do |horse|
        money += Auctions::Bid.winning.where(horse:, bidder_id:).first.current_bid
      end
      money
    end

    def horses_bought(bidder_id)
      Auctions::Horse.joins(:bids).where(bids: { bidder_id: }).sold.count
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
  end
end

