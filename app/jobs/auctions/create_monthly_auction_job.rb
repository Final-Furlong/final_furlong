class Auctions::CreateMonthlyAuctionJob < ApplicationJob
  queue_as :low_priority

  class AuctionNotCreated < StandardError; end

  def perform
    return if Auction.exists?(start_time:, end_time:, title:, auctioneer: final_furlong)

    result = Auctions::AutoAuctionCreator.new.create_auction(auction_params)
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
      auctioneer: final_furlong,
      title:
    }
  end

  def final_furlong
    @final_furlong ||= Account::Stable.find_by(name: "Final Furlong")
  end

  def start_month
    @start_month ||= (Date.current.month == 12) ? 1 : Date.current.month + 1
  end

  def start_year
    @start_year ||= (Date.current.month == 12) ? Date.current.year + 1 : Date.current.year
  end

  def start_time
    @start_time ||= date_of_first_saturday(month: start_month, year: start_year).beginning_of_day
  end

  def end_time
    @end_time ||= (start_time + (Auction::MAXIMUM_DURATION - 1).days).end_of_day
  end

  def title
    @title ||= "#{Date.new(start_year, start_month, 1).strftime("%B %Y")} Final Furlong Auction"
  end

  def date_of_first_saturday(month:, year:)
    weekday = 6 # saturday
    base_date = Date.new(year, month)
    base_weekday = base_date.wday
    if weekday == base_weekday
      base_date
    else
      base_date + weekday - base_weekday
    end
  end
end

