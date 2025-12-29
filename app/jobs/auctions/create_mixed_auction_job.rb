class Auctions::CreateMixedAuctionJob < ApplicationJob
  queue_as :low_priority

  class AuctionNotCreated < StandardError; end

  def perform
    return if Auction.exists?(start_time:, end_time:, title:, auctioneer: final_furlong)
    return if Date.current > Date.new(Date.current.year, 6, 15)

    result = Auctions::MixedAuctionCreator.new.create_auction(auction_params)
    outcome = if result.created?
      { auction_id: result.auction.id, start_date: result.auction.start_time.to_date }
    else
      { created: false, error: result.auction.errors.full_messages.to_sentence }
    end
    store_job_info(outcome:)
    raise AuctionNotCreated, result.auction.errors.full_messages.to_sentence unless result.created?

    Auctions::ConsignHorsesJob.set(wait: 5.minutes).perform_later(auction: result.auction)
  end

  private

  def auction_params
    {
      start_time:,
      end_time:,
      hours_until_sold: 24,
      outside_horses_allowed: true,
      racehorse_allowed_2yo: true,
      racehorse_allowed_3yo: true,
      racehorse_allowed_older: true,
      broodmare_allowed: true,
      stallion_allowed: true,
      yearling_allowed: true,
      weanling_allowed: true,
      reserve_pricing_allowed: false,
      spending_cap_per_stable: 100_000,
      auctioneer: final_furlong,
      title:
    }
  end

  def final_furlong
    return @final_furlong if defined?(@final_furlong)

    @final_furlong = Account::Stable.find_by(name: "Final Furlong")
  end

  def start_time
    @start_time ||= date_of_third_saturday(month: 7, year: Date.current.year).beginning_of_day
  end

  def end_time
    @end_time ||= (start_time + (Auction::MAXIMUM_DURATION - 1).days).end_of_day
  end

  def title
    @title ||= "#{Date.current.year} Mixed Auction"
  end

  def date_of_third_saturday(month:, year:)
    weekday = 6 # saturday
    base_date = Date.new(year, month)
    base_weekday = base_date.wday
    base_date + ((weekday > base_weekday) ? weekday - base_weekday : 7 - base_weekday + weekday) + 7 * 2
  end
end

