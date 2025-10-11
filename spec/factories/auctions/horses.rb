FactoryBot.define do
  factory :auction_horse, class: "Auctions::Horse" do
    auction factory: :auction
    horse
  end

  trait :with_comment do
    comment { SecureRandom.alphanumeric(20) }
  end

  trait :with_reserve_price do
    reserve_price { Faker::Number.number(digits: 5) }
  end

  trait :with_max_price do
    max_price { Faker::Number.number(digits: 6) }
  end

  trait :sold do
    sold_at { 1.minute.ago }
  end
end

# == Schema Information
#
# Table name: auction_horses
#
#  id            :uuid             not null, primary key
#  comment       :text
#  max_price     :integer
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

