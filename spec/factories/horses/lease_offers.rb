FactoryBot.define do
  factory :lease_offer, class: "Horses::LeaseOffer" do
    horse
    owner { horse.owner }
    leaser { nil }
    offer_start_date { Date.current }
    duration_months { 12 }
  end
end

# == Schema Information
#
# Table name: lease_offers
# Database name: primary
#
#  id               :bigint           not null, primary key
#  duration_months  :integer          not null
#  fee              :integer          default(0), not null
#  new_members_only :boolean          default(FALSE), not null
#  offer_start_date :date             not null, indexed
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  horse_id         :bigint           not null, uniquely indexed
#  leaser_id        :bigint           indexed
#  owner_id         :bigint           not null, indexed
#
# Indexes
#
#  index_lease_offers_on_horse_id          (horse_id) UNIQUE
#  index_lease_offers_on_leaser_id         (leaser_id)
#  index_lease_offers_on_offer_start_date  (offer_start_date)
#  index_lease_offers_on_owner_id          (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (leaser_id => stables.id)
#  fk_rails_...  (owner_id => stables.id)
#

