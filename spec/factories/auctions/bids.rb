FactoryBot.define do
  factory :auction_bid, class: "Auctions::Bid" do
    auction factory: :auction
    horse { association :auction_horse, auction: }
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
#  id               :bigint           not null, primary key
#  comment          :text
#  current_bid      :integer          default(0), not null
#  maximum_bid      :integer
#  notify_if_outbid :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auction_id       :integer          indexed
#  bidder_id        :integer          indexed
#  horse_id         :integer          indexed
#  old_auction_id   :uuid             not null, indexed
#  old_bidder_id    :uuid             not null, indexed
#  old_horse_id     :uuid             not null, indexed
#  old_id           :uuid             indexed
#
# Indexes
#
#  index_auction_bids_on_auction_id      (auction_id)
#  index_auction_bids_on_bidder_id       (bidder_id)
#  index_auction_bids_on_horse_id        (horse_id)
#  index_auction_bids_on_old_auction_id  (old_auction_id)
#  index_auction_bids_on_old_bidder_id   (old_bidder_id)
#  index_auction_bids_on_old_horse_id    (old_horse_id)
#  index_auction_bids_on_old_id          (old_id)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (bidder_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (horse_id => auction_horses.id) ON DELETE => cascade ON UPDATE => cascade
#

