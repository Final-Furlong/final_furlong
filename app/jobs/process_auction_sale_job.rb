class ProcessAuctionSaleJob < ApplicationJob
  queue_as :default

  limits_concurrency to: 1, key: ->(bidder_id) { bidder_id }, duration: 5.minutes

  class AuctionNotCreated < StandardError; end

  def perform(bid:, horse:, auction:, bidder:)
    return if horse.sold?

    winning_bid = Auctions::Bid.winning.find_by(auction:, horse:)
    if winning_bid && winning_bid != bid
      wait(1.minute).perform_later(bid: winning_bid, auction:, horse:, bidder: winning_bid.bidder)
      return
    end

    Auctions::HorseSeller.new.process_sale(bid: winning_bid)
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

