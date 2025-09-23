module Auctions
  class Bid < ApplicationRecord
    self.table_name = "auction_bids"

    belongs_to :auction, class_name: "::Auction"
    belongs_to :horse, class_name: "Auctions::Horse"
    belongs_to :bidder, class_name: "Account::Stable"

    validates :maximum_bid, numericality: { greater_than_or_equal_to: :current_bid }, allow_blank: true
    validates :email_if_outbid, inclusion: { in: [true, false] }
  end
end

# == Schema Information
#
# Table name: auction_bids
#
#  id              :uuid             not null, primary key
#  comment         :text
#  current_bid     :integer          default(0), not null
#  email_if_outbid :boolean          default(FALSE), not null
#  maximum_bid     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  auction_id      :uuid             indexed
#  bidder_id       :uuid             indexed
#  horse_id        :uuid             indexed
#
# Indexes
#
#  index_auction_bids_on_auction_id  (auction_id)
#  index_auction_bids_on_bidder_id   (bidder_id)
#  index_auction_bids_on_horse_id    (horse_id)
#
# Foreign Keys
#
#  fk_rails_...  (bidder_id => stables.id)
#  fk_rails_...  (horse_id => auction_horses.id)
#

