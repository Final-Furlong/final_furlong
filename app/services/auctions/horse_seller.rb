module Auctions
  class HorseSeller < ApplicationService
    attr_reader :bid, :auction_horse, :horse, :seller

    def process_sale(bid:)
      @bid = bid
      result = Result.new(sold: false, bid:, error: nil)

      @auction_horse = bid.horse
      @horse = auction_horse.horse
      @seller = horse.owner
      auction = bid.auction

      unless auction.active? || auction.recently_ended?
        result.error = error("auction_inactive")
        return result
      end

      if auction_horse.sold?
        result.error = error("horse_sold")
        return result
      end

      if DateTime.current < bid.updated_at + auction.hours_until_sold.hours && DateTime.current < auction.end_time
        ProcessAuctionSaleJob.set(wait_until: bid.updated_at + auction.hours_until_sold.hours).perform_later(bid:)
        result.error = error("bid_timeout_not_met")
        return result
      end

      horse_max_price = auction_horse.maximum_price.to_i
      if horse_max_price.positive?
        if Auctions::Bid.where.not(id: bid.id).with_bid_matching(horse_max_price).exists?(horse: auction_horse)
          all_max_bidders = Auctions::Bid.with_bid_matching(horse_max_price).select { |max_bid|
            max_bid.bidder.available_balance.to_i >= horse_max_price
          }
          if all_max_bidders.empty?
            Auctions::BidDeleter.new.delete_bids(bids: Auctions::Bid.with_bid_matching(horse_max_price).to_a)
            result.error = error("cannot_afford_bid")
            return result
          else
            bid = all_max_bidders.sample
          end
        end
      end
      buyer = bid.bidder

      available_balance = buyer.available_balance
      if available_balance.nil? || available_balance < bid.current_bid
        Auctions::BidDeleter.new.delete_bids(bids: [bid])
        result.error = error("cannot_afford_bid")
        return result
      end

      if buyer == horse.owner
        result.error = error("bidder_is_owner")
        return result
      end

      horse_reserve = auction_horse.reserve_price.to_i
      if horse_reserve.positive?
        if bid.current_bid < horse_reserve
          result.error = error("reserve_not_met")
          return result
        end
      end

      horse_max = auction.horse_purchase_cap_per_stable.to_i
      if horse_max.positive?
        if horses_bought(buyer.id) >= horse_max
          result.error = error("bought_max_horses")
          return result
        end
      end

      money_max = auction.spending_cap_per_stable.to_i
      if money_max.positive?
        if money_spent(buyer.id) + bid.current_bid > money_max
          result.error = error("spent_max_money")
          return result
        end
      end

      result.error = nil
      ActiveRecord::Base.transaction do
        description = "#{auction.title}: Purchased #{horse.budget_name} (ID# #{horse.legacy_id}) from #{seller.name}"
        Accounts::BudgetTransactionCreator.new.create_transaction(stable: buyer, description:, amount: bid.current_bid * -1)

        new_points = buyer.newbie? ? 6 : 2
        Legacy::Activity.create_new(
          legacy_id: buyer.legacy_id, points: new_points
        )

        description = "#{auction.title}: Sold #{horse.budget_name} (ID# #{horse.legacy_id}) to #{buyer.name}"
        Accounts::BudgetTransactionCreator.new.create_transaction(stable: seller, description:, amount: bid.current_bid)

        new_points = seller.newbie? ? 6 : 2
        Legacy::Activity.create_new(legacy_id: seller.legacy_id, points: new_points)

        Legacy::TrainingSchedule.where(Horse: horse.legacy_id).delete_all
        Legacy::TrainingScheduleHorse.where(Horse: horse.legacy_id).delete_all
        # rubocop:disable Rails/SkipsModelValidations
        Legacy::ViewRacehorses.where(horse_id: horse.legacy_id).update_all("Owner = #{buyer.legacy_id}, can_be_sold = 0")
        # rubocop:enable Rails/SkipsModelValidations
        Legacy::HorseSale.create!(
          Date: Date.current + 4.years,
          Horse: horse.legacy_id,
          Seller: seller.legacy_id,
          Buyer: buyer.legacy_id,
          Price: bid.current_bid,
          PT: false
        )
        Legacy::Horse.where(ID: horse.legacy_id).update(
          Owner: buyer.legacy_id,
          SalePrice: -1,
          SellTo: 0,
          can_be_sold: 0
        )
        Legacy::ViewTrainingSchedules.where(horse_id: horse.legacy_id).update(
          training_schedule_id: nil, training_schedule_horse_id: nil, owner: buyer.legacy_id
        )
        if Legacy::RaceEntry.joins(race: :type).merge(Legacy::RaceType.claiming).exists?(Horse: horse.legacy_id)
          Legacy::RaceEntry.joins(race: :type).merge(Legacy::RaceType.claiming).where(Horse: horse.legacy_id).delete_all
        end
        if Legacy::Horse.where("DOB > ?", Date.current + 4.years).exists?(Dam: horse.legacy_id)
          Legacy::Horse.where("DOB > ?", Date.current + 4.years).where(Dam: horse.legacy_id).update(Owner: buyer.legacy_id)
        end
        if Horses::Horse.unborn.exists?(dam: horse)
          Horses::Horse.unborn.where(dam: horse).update(owner: buyer)
        end
        auction_horse.update(sold_at: Time.current)
        horse.update(owner: buyer)

        result.sold = true
      rescue ActiveRecord::ActiveRecordError
        result.sold = false
      end

      result
    end

    class Result
      attr_reader :bid, :sold, :error
      attr_writer :bid, :error, :sold

      def initialize(sold:, bid:, error: nil)
        @sold = sold
        @bid = bid
        @error = error
      end

      def sold?
        @sold
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

    def error(key)
      I18n.t("services.auctions.horse_seller.#{key}")
    end
  end
end

