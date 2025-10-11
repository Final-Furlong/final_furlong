module Auctions
  class Horse < ApplicationRecord
    self.table_name = "auction_horses"
    self.ignored_columns += ["max_price"]

    belongs_to :auction, class_name: "::Auction"
    belongs_to :horse, class_name: "Horses::Horse"
    has_many :bids, class_name: "Auctions::Bid", dependent: :destroy

    validates :maximum_price, numericality: { greater_than_or_equal_to: :reserve_price }, if: :reserve_price, allow_blank: true
    validates :horse_id, uniqueness: { scope: :auction_id }

    scope :sold, -> { where.not(sold_at: nil) }
    scope :unsold, -> { where(sold_at: nil) }

    def sold?
      sold_at.present?
    end
  end
end

# == Schema Information
#
# Table name: auction_horses
#
#  id            :uuid             not null, primary key
#  comment       :text
#  maximum_price :integer
#  reserve_price :integer
#  sold_at       :datetime         indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  auction_id    :uuid             not null, indexed
#  horse_id      :uuid             not null, uniquely indexed
#
# Indexes
#
#  index_auction_horses_on_auction_id  (auction_id)
#  index_auction_horses_on_horse_id    (horse_id) UNIQUE
#  index_auction_horses_on_sold_at     (sold_at)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id)
#  fk_rails_...  (horse_id => horses.id)
#

