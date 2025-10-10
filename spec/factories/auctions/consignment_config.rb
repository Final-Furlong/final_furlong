FactoryBot.define do
  factory :auction_consignment_config, class: "Auctions::ConsignmentConfig" do
    auction factory: :auction

    horse_type { "racehorse" }
    minimum_age { 2 }
    maximum_age { 5 }
    minimum_count { 2 }
  end

  trait :stallion do
    horse_type { "stallion" }
    minimum_age { 4 }
    maximum_age { 15 }
    minimum_count { 2 }
  end

  trait :broodmare do
    horse_type { "broodmare" }
    minimum_age { 4 }
    maximum_age { 15 }
    minimum_count { 2 }
  end

  trait :yearling do
    horse_type { "yearling" }
    minimum_age { 1 }
    maximum_age { 1 }
    minimum_count { 2 }
  end

  trait :weanling do
    horse_type { "weanling" }
    minimum_age { 0 }
    maximum_age { 0 }
    minimum_count { 2 }
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
#  auction_id      :uuid             not null, indexed
#  bidder_id       :uuid             not null, indexed
#  horse_id        :uuid             not null, indexed
#
# Indexes
#
#  index_auction_bids_on_auction_id  (auction_id)
#  index_auction_bids_on_bidder_id   (bidder_id)
#  index_auction_bids_on_horse_id    (horse_id)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id)
#  fk_rails_...  (bidder_id => stables.id)
#  fk_rails_...  (horse_id => auction_horses.id)
#

