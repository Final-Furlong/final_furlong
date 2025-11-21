FactoryBot.define do
  factory :sale_offer, class: "Horses::SaleOffer" do
    horse
    owner { horse.owner }
    buyer { nil }
    offer_start_date { Date.current }
    price { 1000 }
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

