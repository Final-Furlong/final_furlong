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
    maximum_price { Faker::Number.number(digits: 6) }
  end

  trait :sold do
    sold_at { 1.minute.ago }
  end
end

# == Schema Information
#
# Table name: auction_horses
#
#  id            :bigint           not null, primary key
#  comment       :text
#  maximum_price :integer
#  reserve_price :integer
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
#  index_auction_horses_on_old_id      (old_id)
#  index_auction_horses_on_sold_at     (sold_at)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

