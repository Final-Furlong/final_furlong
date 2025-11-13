FactoryBot.define do
  factory :lease, class: "Horses::Lease" do
    horse
    owner { horse.owner }
    leaser { association :stable }
    start_date { Date.current }
    end_date { Date.current + 1.year }
  end
end

# == Schema Information
#
# Table name: leases
# Database name: primary
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE), not null, indexed
#  early_termination_date :date             indexed
#  end_date               :date             not null, indexed
#  fee                    :integer          default(0), not null
#  start_date             :date             not null, indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  horse_id               :bigint           not null, uniquely indexed
#  leaser_id              :bigint           not null, indexed
#  owner_id               :bigint           not null, indexed
#
# Indexes
#
#  index_leases_on_active                  (active)
#  index_leases_on_early_termination_date  (early_termination_date)
#  index_leases_on_end_date                (end_date)
#  index_leases_on_horse_id                (horse_id) UNIQUE WHERE (active = true)
#  index_leases_on_leaser_id               (leaser_id)
#  index_leases_on_owner_id                (owner_id)
#  index_leases_on_start_date              (start_date)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (leaser_id => stables.id)
#  fk_rails_...  (owner_id => stables.id)
#

