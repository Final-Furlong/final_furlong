module Horses
  class SaleOffer < ApplicationRecord
    MAX_OFFER_PERIOD_DAYS = 60
    MAX_NEWBIE_PRICE = 50_000
    MINIMUM_AGE = 3.months
    MINIMUM_WAIT_FROM_SALE = 6.months
    MINIMUM_RACES = 3

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :owner, class_name: "Account::Stable"
    belongs_to :buyer, class_name: "Account::Stable", optional: true

    validates :offer_start_date, :price, presence: true
    validates :offer_start_date, comparison: { greater_than_or_equal_to: -> { Date.current } }
    validates :offer_start_date, comparison: { less_than_or_equal_to: :maximum_offer_date }
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :price, numericality: { only_integer: true, less_than_or_equal_to: MAX_NEWBIE_PRICE }, if: :new_members_only
    validates :new_members_only, inclusion: { in: [true, false] }
    validates :new_members_only, inclusion: { in: [false] }, if: :buyer

    # rubocop:disable Rails/WhereEquals
    scope :active, -> { where(offer_start_date: ..Date.current) }
    scope :expired, -> { where(offer_start_date: ..(Date.current - (MAX_OFFER_PERIOD_DAYS + 1).days)) }
    scope :starts_today, -> { where(offer_start_date: Date.current) }
    scope :with_buyer, -> { where.not(buyer_id: nil) }
    scope :sold_by, ->(seller) { where(owner_id: seller.id) }

    scope :offered_to, ->(stable) {
      where("sale_offers.buyer_id = :id", id: stable.id)
    }
    scope :with_owner, ->(owner) { where(owner:) }
    scope :without_owner, ->(owner) { where.not(owner:) }
    scope :new_members_only, -> { where("sale_offers.buyer_id IS NULL") }
    scope :non_new_members_only, -> {
      where("sale_offers.buyer_id IS NULL AND sale_offers.new_members_only = FALSE")
    }
    scope :valid_for_stable, ->(stable) {
      if stable.newbie?
        active.new_members_only.without_owner(stable)
          .or(active.without_owner(stable).offered_to(stable))
      else
        active.non_new_members_only.without_owner(stable)
          .or(active.without_owner(stable).offered_to(stable))
      end
    }
    # rubocop:enable Rails/WhereEquals

    def maximum_offer_date
      Date.current + MAX_OFFER_PERIOD_DAYS.days
    end
  end
end

# == Schema Information
#
# Table name: sale_offers
# Database name: primary
#
#  id               :bigint           not null, primary key
#  new_members_only :boolean          default(FALSE), not null
#  offer_start_date :date             not null, indexed
#  price            :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  buyer_id         :bigint           indexed
#  horse_id         :bigint           not null, uniquely indexed
#  owner_id         :bigint           not null, indexed
#
# Indexes
#
#  index_sale_offers_on_buyer_id          (buyer_id)
#  index_sale_offers_on_horse_id          (horse_id) UNIQUE
#  index_sale_offers_on_offer_start_date  (offer_start_date)
#  index_sale_offers_on_owner_id          (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (buyer_id => stables.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (owner_id => stables.id)
#

