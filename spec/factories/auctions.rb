FactoryBot.define do
  factory :auction do
    auctioneer factory: :stable
    title { SecureRandom.alphanumeric(20) }
    start_time { Date.current + 10.days }
    end_time { Date.current + 20.days }
    racehorse_allowed_2yo { true }
    racehorse_allowed_3yo { true }
    racehorse_allowed_older { true }

    trait :allow_reserve do
      reserve_pricing_allowed { true }
    end

    trait :allow_outside do
      outside_horses_allowed { true }
    end

    trait :with_spending_cap do
      transient do
        spending_cap { 100_000 }
      end

      after(:build) do |auction, context|
        auction.spending_cap_per_stable = context.spending_cap
      end
    end

    trait :current do
      after(:create) do |auction|
        auction.update_column(:start_time, Date.current - 5.days)
        auction.update_column(:end_time, Date.current + 5.days)
      end
    end

    trait :past do
      after(:create) do |auction|
        auction.update_column(:start_time, Date.current - 20.days)
        auction.update_column(:end_time, Date.current - 20.days)
      end
    end
  end
end

# == Schema Information
#
# Table name: auctions
# Database name: primary
#
#  id                            :bigint           not null, primary key
#  broodmare_allowed             :boolean          default(FALSE), not null
#  end_time                      :datetime         not null, indexed
#  horse_purchase_cap_per_stable :integer
#  horses_count                  :integer          default(0), not null
#  hours_until_sold              :integer          default(12), not null
#  outside_horses_allowed        :boolean          default(FALSE), not null
#  pending_sales_count           :integer          default(0), not null
#  racehorse_allowed_2yo         :boolean          default(FALSE), not null
#  racehorse_allowed_3yo         :boolean          default(FALSE), not null
#  racehorse_allowed_older       :boolean          default(FALSE), not null
#  reserve_pricing_allowed       :boolean          default(FALSE), not null
#  slug                          :string           uniquely indexed
#  sold_horses_count             :integer          default(0), not null
#  spending_cap_per_stable       :integer
#  stallion_allowed              :boolean          default(FALSE), not null
#  start_time                    :datetime         not null, indexed
#  title                         :string(500)      not null
#  weanling_allowed              :boolean          default(FALSE), not null
#  yearling_allowed              :boolean          default(FALSE), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  auctioneer_id                 :bigint           not null, indexed
#  public_id                     :string(12)
#
# Indexes
#
#  index_auctions_on_auctioneer_id  (auctioneer_id)
#  index_auctions_on_end_time       (end_time)
#  index_auctions_on_slug           (slug) UNIQUE
#  index_auctions_on_start_time     (start_time)
#  index_auctions_on_title          (lower((title)::text)) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (auctioneer_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#

