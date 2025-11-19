module Auctions
  class BidDeleter < ApplicationService
    attr_reader :auction_horse, :disable_job_trigger

    def delete_bids(bids:, disable_job_trigger: false)
      auction = bids.first.auction
      horse = bids.first.horse
      ActiveRecord::Base.transaction do
        bids.map(&:destroy!)

        if Auctions::Bid.winning.exists?(horse:)
          previous_bid = Auctions::Bid.winning.find_by!(horse:)
          previous_bid.update(bid_at: Time.current, current_high_bid: true)
        end
      end
      schedule_next_sales_job(auction:, disabled: disable_job_trigger)
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

    private

    def schedule_next_sales_job(auction:, disabled: false)
      return if disabled

      return unless Auctions::Bid.where(auction:).current_high_bid.sale_time_not_met.exists?

      next_updated_at = Auctions::Bid.where(auction:).current_high_bid.sale_time_not_met.minimum(:updated_at)
      return if schedule_exists?(auction:, time: next_updated_at + auction.hours_until_sold.hours)

      Auctions::ProcessSalesJob.set(wait_until: next_updated_at + auction.hours_until_sold.hours).perform_later(auction)
    end

    def schedule_exists?(auction:, time:)
      SolidQueue::Job.scheduled.where(class_name: "Auctions::ProcessSalesJob")
        .where("arguments LIKE ?", "%#{auction.id}%")
        .where(["scheduled_at > ?", 10.minutes.from_now])
        .exists?(["scheduled_at < ?", time])
    end
  end
end

