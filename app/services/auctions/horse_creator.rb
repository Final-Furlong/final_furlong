module Auctions
  class HorseCreator < ApplicationService
    attr_reader :auction_horse

    def create_horse(params)
      auction = Auction.find_by(id: params[:auction_id])
      result = Result.new(created: false, auction: nil, horse: nil, stable: nil, error: nil)
      unless auction
        result.error = error("auction_not_found")
        return result
      end
      result.auction = auction

      unless auction.future?
        result.error = error("auction_not_future")
        return result
      end

      horse = Horses::Horse.find_by(id: params[:horse_id])
      unless horse
        result.error = error("horse_not_found")
        return result
      end
      result.horse = horse

      stable = Account::Stable.find_by(id: params[:stable_id])
      unless stable
        result.error = error("stable_not_found")
        return result
      end
      result.stable = stable

      if horse.owner != stable
        result.error = error("horse_not_owned")
        return result
      end

      if auction.auctioneer != stable && !auction.outside_horses_allowed
        result.error = error("outside_horses_not_allowed")
        return result
      end

      if horse.dead?
        result.error = error("dead_horses_not_allowed")
        return result
      end

      if horse.unborn?
        result.error = error("unborn_horses_not_allowed")
        return result
      end

      if !auction.broodmare_allowed && horse.broodmare?
        result.error = error("broodmares_not_allowed")
        return result
      end
      if !auction.stallion_allowed? && horse.stud?
        result.error = error("stallions_not_allowed")
        return result
      end
      if horse.racehorse?
        if !auction.racehorse_allowed_2yo && horse.age == 2
          result.error = error("racehorse_2yo_not_allowed")
          return result
        end
        if !auction.racehorse_allowed_3yo && horse.age == 3
          result.error = error("racehorse_3yo_not_allowed")
          return result
        end
        if !auction.racehorse_allowed_older && horse.age > 3
          result.error = error("racehorse_older_not_allowed")
          return result
        end
      end
      if !auction.yearling_allowed? && horse.yearling?
        result.error = error("yearlings_not_allowed")
        return result
      end
      if !auction.weanling_allowed? && horse.weanling?
        result.error = error("weanlings_not_allowed")
        return result
      end

      auction_horse = Auctions::Horse.new(horse:, auction:, sold_at: nil, seller: horse.owner)
      if (reserve_price = params[:reserve_price].to_i).positive?
        if !auction.reserve_pricing_allowed
          result.error = error("reserves_not_allowed")
          return result
        else
          auction_horse.reserve_price = reserve_price
          available_balance = stable.available_balance
          if available_balance.to_i <= reserve_price * Config::Auctions.reserve_fee
            result.error = error("cannot_afford_reserve_fee")
            return result
          end
        end
      end

      auction_horse.comment = params[:comment] if params[:comment].present?
      spending_cap = auction.spending_cap_per_stable.to_i
      auction_horse.maximum_price = spending_cap if spending_cap.positive?

      ActiveRecord::Base.transaction do
        if reserve_price
          reserve_fee = (reserve_price * Config::Auctions.reserve_fee).to_i * -1
          description = "Consigning #{horse.name} to #{auction.title}"
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: reserve_fee)
        end
        Legacy::Horse.where(ID: horse.legacy_id).update(consigned_auction_id: auction.id)
        if auction_horse.save!
          result.auction_horse = auction_horse
          result.error = nil
          result.created = true
        end
      rescue ActiveRecord::ActiveRecordError => e
        result.auction_horse = auction_horse
        result.error = e.message
      end
      result
    end

    class Result
      attr_accessor :auction, :horse, :stable, :error, :created, :auction_horse

      def initialize(created:, auction:, horse:, stable:, auction_horse: nil, error: nil)
        @created = created
        @auction = auction
        @auction_horse = auction_horse
        @horse = horse
        @stable = stable
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def error(key)
      I18n.t("services.auctions.horse_creator.#{key}")
    end
  end
end

