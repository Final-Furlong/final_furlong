FactoryBot.define do
  factory :horse_sale, class: "Horses::Sale" do
    horse
    seller { horse.owner }
    buyer { association :stable }
    price { 10_000 }
    date { Date.current }

    trait :public do
      private { false }
    end
  end
end

# == Schema Information
#
# Table name: horse_sales
# Database name: primary
#
#  id         :bigint           not null, primary key
#  date       :date             not null, indexed
#  price      :integer          default(0), not null
#  private    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  buyer_id   :bigint           not null, indexed
#  horse_id   :bigint           not null, indexed
#  seller_id  :bigint           not null, indexed
#
# Indexes
#
#  index_horse_sales_on_buyer_id   (buyer_id)
#  index_horse_sales_on_date       (date)
#  index_horse_sales_on_horse_id   (horse_id)
#  index_horse_sales_on_seller_id  (seller_id)
#
# Foreign Keys
#
#  fk_rails_...  (buyer_id => stables.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (seller_id => stables.id)
#

