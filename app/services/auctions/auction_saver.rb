module Auctions
  class AuctionSaver < ApplicationService
    attr_reader :auction

    def save_auction(auction_params:, auction:)
      @auction = auction
      days = auction_params.delete(:duration_days)
      auction_params[:spending_cap_per_stable] = nil if auction_params[:spending_cap_per_stable].to_i.zero?
      auction_params[:start_time] = auction_params[:start_time].to_datetime.beginning_of_day
      auction_params[:end_time] = auction_params[:start_time] + days.to_i.days
      auction_params[:auctioneer] ||= Current.stable
      auction_params[:title] ||= I18n.t("auctions.form.title", stable: Current.stable.name)
      if auction.update(auction_params)
        Result.new(created: true, auction:)
      else
        pd auction.errors.inspect
        Result.new(created: false, auction:)
      end
    end

    class Result
      attr_reader :auction

      def initialize(created:, auction:)
        @created = created
        @auction = auction
      end

      def created?
        @created
      end
    end
  end
end

