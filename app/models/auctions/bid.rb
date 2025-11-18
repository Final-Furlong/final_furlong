module Auctions
  class Bid < ApplicationRecord
    self.table_name = "auction_bids"

    MINIMUM_BID = 1000
    MINIMUM_INCREMENT = 500

    belongs_to :auction, class_name: "::Auction"
    belongs_to :horse, class_name: "Auctions::Horse"
    belongs_to :bidder, class_name: "Account::Stable"

    validates :current_bid, presence: true
    validates :current_bid, numericality: { greater_than_or_equal_to: MINIMUM_BID }, allow_nil: true
    validates :maximum_bid, numericality: { greater_than_or_equal_to: :current_bid }, allow_nil: true
    validates :notify_if_outbid, :current_high_bid, inclusion: { in: [true, false] }

    scope :winning, -> { order(maximum_bid: :desc, current_bid: :desc, bid_at: :desc) }
    scope :with_bid_matching, ->(amount) { where("GREATEST(current_bid, CAST(maximum_bid AS integer)) >= ?", amount) }
    scope :current_high_bid, -> { where(current_high_bid: true) }
    scope :sale_time_met, -> { joins(:auction).where("#{table_name}.bid_at <= CURRENT_TIMESTAMP - (auctions.hours_until_sold * INTERVAL '1 hour')") }
    scope :sale_time_not_met, -> { joins(:auction).where("#{table_name}.bid_at > CURRENT_TIMESTAMP - (auctions.hours_until_sold * INTERVAL '1 hour')") }
  end
end

# == Schema Information
#
# Table name: auction_bids
# Database name: primary
#
#  id               :bigint           not null, primary key
#  bid_at           :datetime         not null, indexed
#  comment          :text
#  current_bid      :integer          default(0), not null
#  current_high_bid :boolean          default(FALSE), not null, indexed
#  maximum_bid      :integer
#  notify_if_outbid :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auction_id       :bigint           not null, indexed
#  bidder_id        :bigint           not null, indexed
#  horse_id         :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_auction_bids_on_auction_id        (auction_id)
#  index_auction_bids_on_bid_at            (bid_at)
#  index_auction_bids_on_bidder_id         (bidder_id)
#  index_auction_bids_on_current_high_bid  (current_high_bid)
#  index_auction_bids_on_horse_id          (horse_id) UNIQUE WHERE (current_high_bid = true)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (bidder_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (horse_id => auction_horses.id) ON DELETE => cascade ON UPDATE => cascade
#

