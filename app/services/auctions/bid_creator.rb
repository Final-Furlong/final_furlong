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

      bid_params[:maximum_bid] = nil if bid_params[:maximum_bid].to_i.zero?
      bid = Auctions::Bid.new(
        auction:,
        horse: auction_horse,
        bidder:,
        current_bid: bid_params[:current_bid],
        maximum_bid: bid_params[:maximum_bid].presence,
        notify_if_outbid: bid_params[:notify_if_outbid].to_s == "yes",
        current_high_bid: true
      )

      bid_params[:current_bid] = bid_params[:current_bid].to_i
      bid_params[:maximum_bid] = bid_params[:maximum_bid].to_i if bid_params[:maximum_bid]
      available_balance = bidder.available_balance.to_i
      if available_balance < bid_params[:current_bid] || available_balance < bid_params[:maximum_bid].to_i
        if available_balance < bid_params[:current_bid]
          bid.errors.add(:current_bid, :cannot_afford)
        else
          bid.errors.add(:maximum_bid, :cannot_afford)
        end
        result.bid = bid
        result.error = error("cannot_afford_bid")
        return result
      end

      max_bid_amount = [bid_params[:current_bid], bid_params[:maximum_bid]].map(&:to_i).max
      increment = Config::Auctions.minimum_increment

      if (bid_params[:current_bid] % increment).positive? || (max_bid_amount % increment).positive?
        bid.errors.add(:maximum_bid, :invalid_increment)
        result.bid = bid
        result.error = I18n.t("services.auctions.bid_creator.bid_value_invalid", increment:)
        return result
      end

      if bid_params[:bidder_id].to_i == Horses::Horse.where(id: auction_horse.horse_id).pick(:owner_id)
        bid.errors.add(:base, :cannot_be_owner)
        result.bid = bid
        result.error = error("bidder_is_owner")
        return result
      end

      horse_reserve = auction_horse.reserve_price.to_i
      if horse_reserve.positive?
        if max_bid_amount < horse_reserve
          bid.errors.add(:current_bid, :reserve_not_met)
          result.bid = bid
          result.error = error("reserve_not_met")
          bid_params[:current_bid] = max_bid_amount
        elsif bid_params[:current_bid] < horse_reserve
          bid_params[:current_bid] = horse_reserve
        end
      end

      horse_max = auction.horse_purchase_cap_per_stable.to_i
      if horse_max.positive?
        if horses_bought(auction, bid_params[:bidder_id]) >= horse_max
          bid.errors.add(:base, :bought_max_horses)
          result.bid = bid
          result.error = error("bought_max_horses")
          return result
        end
      end

      money_max = auction.spending_cap_per_stable.to_i
      if money_max.positive?
        if money_spent(auction:, bidder_id: bid_params[:bidder_id]) + max_bid_amount > money_max
          bid.errors.add(:base, :spent_max_money)
          result.bid = bid
          result.error = error("spent_max_money")
          return result
        end
      end

      has_previous_bid = previous_bid.present?
      if bid_params[:bidder_id] == previous_bid&.bidder_id && horse_reserve.zero? ||
          (horse_reserve.positive? && bid.errors.where(:current_bid, :reserve_not_met).blank? &&
            has_previous_bid && previous_bid.current_bid >= horse_reserve)
        bid.errors.add(:base, :is_current_high_bidder)
        result.bid = bid
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
          minimum_amount = (bid_params[:maximum_bid].to_i == max_bid) ? max_bid : [previous_bid.current_bid, bid_params[:maximum_bid].to_i].max
          minimum_display_amount = [minimum_amount + increment, bid_params[:current_bid] - extra_invalid_amount.to_i].max
          minimum_display_amount = Game::MoneyFormatter.new(minimum_display_amount).to_s
          bid.errors.add(:current_bid, :greater_than_or_equal_to, count: minimum_display_amount)
          result.bid = bid
          result.error = I18n.t("services.auctions.bid_creator.bid_not_high_enough", number: minimum_display_amount)
          return result
        elsif max_bid.positive? && bid_params[:maximum_bid].to_i > max_bid &&
            bid_params[:current_bid] < previous_max_bid + Config::Auctions.minimum_increment
          bid_params[:current_bid] = previous_max_bid + Config::Auctions.minimum_increment
        end

        result.error = nil unless result.error == error("reserve_not_met")
        bid.assign_attributes(
          current_bid: bid_params[:current_bid],
          maximum_bid: bid_params[:maximum_bid].presence,
          current_high_bid: true
        )

        if bid.valid?
          update_old_bids(auction:, horse: auction_horse)
          result.created = bid.save
          if result.created? && has_previous_bid
            notify_previous_bidder(auction:, auction_horse:)
            previous_bid.update(current_bid: previous_bid.maximum_bid) if previous_max_bid.positive?
          end
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

    def notify_previous_bidder(auction:, auction_horse:)
      return unless previous_bid
      return unless previous_bid.notify_if_outbid

      horse = auction_horse.horse
      ::AuctionOutbidNotification.create!(
        user: previous_bid.bidder.user,
        params: {
          horse_id: horse.slug,
          horse_name: horse.name,
          auction: auction.title,
          auction_slug: auction.slug,
          horse_slug: auction_horse.slug
        }
      )
    end

    def update_old_bids(auction:, horse:)
      Auctions::Bid.where(auction:, horse:, bid_at: ..Time.current).find_each do |bid|
        bid.update(current_high_bid: false)
      end
    end

    def money_spent(auction:, bidder_id:)
      money = 0
      auction.horses.joins(:bids).where(bids: { bidder_id:, current_high_bid: true }).sold.find_each do |horse|
        money += auction.bids.current_high_bid.where(horse:, bidder_id:).first&.current_bid.to_i
      end
      money
    end

    def horses_bought(auction, bidder_id)
      sold_horses = auction.horses.joins(:horse).where(horses: { owner_id: bidder_id }).sold.count
      max_bid_horses = Auctions::Bid.joins(:horse).current_high_bid.merge(Auctions::Horse.unsold).where(bidder_id:).count
      sold_horses + max_bid_horses
    end

    def previous_bid(id: nil)
      @previous_bid ||= Auctions::Bid.where(horse: auction_horse)
        .where.not(id:)
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

