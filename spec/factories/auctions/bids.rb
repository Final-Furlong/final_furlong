FactoryBot.define do
  factory :auction_bid, class: "Auctions::Bid" do
    auction factory: :auction
    horse factory: :auction_horse
    bidder factory: :stable
    current_bid { Faker::Number.number(digits: 5) }
  end

  trait :with_max_bid do
    maximum_bid { Faker::Number.number(digits: 6) }
  end

  trait :send_email do
    email_if_outbid { true }
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

