module Auctions
  class Horse < ApplicationRecord
    include PublicIdGenerator
    include FriendlyId

    self.table_name = "auction_horses"

    friendly_id :horse_slug, use: [:slugged, :finders]

    belongs_to :auction, class_name: "::Auction"
    belongs_to :horse, class_name: "Horses::Horse"
    has_many :bids, class_name: "Auctions::Bid", dependent: :destroy

    validates :maximum_price, numericality: { greater_than_or_equal_to: :reserve_price }, if: :reserve_price, allow_blank: true
    validates :horse_id, uniqueness: true

    scope :sold, -> { where.not(sold_at: nil) }
    scope :unsold, -> { where(sold_at: nil) }

    def sold?
      sold_at.present?
    end

    def horse_slug
      return horse&.slug if horse

      public_id
    end

    private

    def should_generate_new_friendly_id?
      horse_changed? || public_id_changed? || super
    end
  end
end

# == Schema Information
#
# Table name: auction_horses
# Database name: primary
#
#  id            :bigint           not null, primary key
#  comment       :text
#  maximum_price :integer
#  reserve_price :integer
#  slug          :string           uniquely indexed
#  sold_at       :datetime         indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  auction_id    :bigint           not null, indexed
#  horse_id      :bigint           not null, uniquely indexed
#  public_id     :string(12)
#
# Indexes
#
#  index_auction_horses_on_auction_id  (auction_id)
#  index_auction_horses_on_horse_id    (horse_id) UNIQUE
#  index_auction_horses_on_slug        (slug) UNIQUE
#  index_auction_horses_on_sold_at     (sold_at)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

