module Auctions
  class Bid < ApplicationRecord
    self.table_name = "auction_bids"

    MINIMUM_BID = 1000
    MINIMUM_INCREMENT = 500

    belongs_to :auction, class_name: "::Auction"
    belongs_to :horse, class_name: "Auctions::Horse"
    belongs_to :bidder, class_name: "Account::Stable"

    after_commit :schedule_sale, on: %i[create update]
    after_commit :unschedule_sale, on: :destroy

    validates :current_bid, presence: true
    validates :current_bid, numericality: { greater_than_or_equal_to: MINIMUM_BID }, allow_blank: true
    validates :maximum_bid, numericality: { greater_than_or_equal_to: :current_bid }, allow_blank: true
    validates :notify_if_outbid, inclusion: { in: [true, false] }

    scope :winning, -> { order(maximum_bid: :desc, current_bid: :desc, updated_at: :desc) }
    scope :with_bid_matching, ->(amount) { where("GREATEST(current_bid, CAST(maximum_bid AS integer)) >= ?", amount) }

    def unschedule_sale
      sale_job.destroy_all if sale_job.exists?
    end

    private

    def schedule_sale
      unschedule_sale
      schedule_job
    end

    def schedule_job
      ProcessAuctionSaleJob.set(wait: auction.hours_until_sold.hours).perform_later(
        bid: self, horse:, auction:, bidder:
      )
    end

    def sale_job
      SolidQueue::Job.where(class_name: "ProcessAuctionSaleJob")
        .where("arguments LIKE ?", "%#{horse_id}%")
        .where("arguments LIKE ?", "%#{auction_id}%")
    end
  end
end

# == Schema Information
#
# Table name: auction_bids
# Database name: primary
#
#  id               :bigint           not null, primary key
#  comment          :text
#  current_bid      :integer          default(0), not null
#  maximum_bid      :integer
#  notify_if_outbid :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auction_id       :bigint           not null, indexed
#  bidder_id        :bigint           not null, indexed
#  horse_id         :bigint           not null, indexed
#
# Indexes
#
#  index_auction_bids_on_auction_id  (auction_id)
#  index_auction_bids_on_bidder_id   (bidder_id)
#  index_auction_bids_on_horse_id    (horse_id)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (bidder_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (horse_id => auction_horses.id) ON DELETE => cascade ON UPDATE => cascade
#

